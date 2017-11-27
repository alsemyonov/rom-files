# frozen_string_literal: true

require 'concurrent/hash'
require 'mime/types/full'
require_relative 'dataset'

module ROM
  module Files
    class Connection
      extend Forwardable

      # @param path [Pathname, #to_s]
      def initialize(path = Pathname.pwd)
        @path = Pathname(path).expand_path
        @data = Concurrent::Hash.new
      end

      # @return [Pathname]
      attr_reader :path

      # Dataset registry
      #
      # @return [Concurrent::Hash]
      #
      # @api private
      attr_reader :data

      # @!method []
      #   @return [Dataset]
      #
      #   @api private
      #
      # @!method size
      #   Return registered datasets count
      #
      #   @return [Integer]
      #
      #   @api private
      def_instance_delegators :data, :[], :size

      # @param name [String, Symbol]
      # @return [Dataset]
      def create_dataset(name)
        mime_type = MIME::Types[name].first
        @data[name] = if mime_type
                        build_dataset(mime_type: mime_type)
                      else
                        build_dataset(inside_paths: [name])
                      end
      end

      def build_dataset(options)
        Dataset.new([], options.merge(connection: self))
      end

      # @return [Boolean]
      def key?(name)
        MIME::Types[name].any? || path_for(name).exist?
      end

      # @param patterns [Array<String>]
      # @param path [Pathname]
      # @param exclude_patterns [Array<String>]
      # @param sorting [#to_proc]
      # @param directories [Boolean]
      # @return [Array<Pathname>]
      def search(patterns, path: self.path, exclude_patterns: EMPTY_ARRAY, sorting: nil, directories: false)
        files = patterns.inject([]) do |result, pattern|
          result + Pathname.glob(path_for(pattern, path: path)).map { |found| found.relative_path_from(path) }
        end
        files = files.reject(&:directory?) unless directories
        files = files.reject do |match|
          exclude_patterns.any? do |pattern|
            match.fnmatch(pattern, File::FNM_EXTGLOB)
          end
        end
        files = files.sort_by(&sorting) if sorting
        files
      end

      # @param id [Pathname, #to_s]
      # @return [String]
      def read(id)
        path_for(id).read
      end

      # @param id [Pathname, #to_s]
      # @param contents [String, #to_s]
      # @return [String]
      def write(id, contents)
        path_for(id).write(contents.to_s)
      end

      # @param id [Pathname, #to_s]
      # @return [String]
      def binread(id)
        path_for(id).binread
      end

      # @param id [Pathname, #to_s]
      # @param contents [String, #to_s]
      # @return [String]
      def binwrite(id, contents)
        path_for(id).binwrite(contents)
      end

      # @param id [Pathname, #to_s]
      def delete(id)
        path_for(id).delete
      end

      private

      # @return [Pathname]
      def path_for(name, path: self.path)
        path.join(name.to_s)
      end
    end
  end
end
