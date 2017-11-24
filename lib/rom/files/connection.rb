# frozen_string_literal: true

require 'concurrent/hash'
require 'mime/types/full'
require_relative 'dataset'

module ROM
  module Files
    class Connection
      extend Forwardable

      # @param path [Pathname, #to_s]
      def initialize(path)
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
        types = MIME::Types[name]
        @data[name] = if types.any?
                        Dataset.new(path, mime_type: types.first, connection: self)
                      else
                        Dataset.new(path_for(name), connection: self)
                      end
      end

      # @return [Boolean]
      def key?(name)
        MIME::Types[name].any? || path_for(name).exist?
      end

      # @return [Array<Pathname>]
      def search(patterns, path: self.path, excludes: EMPTY_ARRAY, sorting: nil, directories: false)
        files = patterns.inject([]) do |result, pattern|
          result + Pathname.glob(path.join(pattern)).map { |found| found.relative_path_from(path) }
        end
        files = files.reject(&:directory?) unless directories
        files = files.reject do |match|
          excludes.any? do |pattern|
            match.fnmatch(pattern, File::FNM_EXTGLOB)
          end
        end
        files = files.sort_by(&sorting) if sorting
        files
      end

      # @param id [Pathname, #to_s]
      # @return [String]
      def read(id)
        path.join(id).read
      end

      # @param id [Pathname, #to_s]
      # @param contents [String, #to_s]
      # @return [String]
      def write(id, contents)
        path.join(id).write(contents.to_s)
      end

      # @param id [Pathname, #to_s]
      # @return [String]
      def binread(id)
        path.join(id).binread
      end

      # @param id [Pathname, #to_s]
      # @param contents [String, #to_s]
      # @return [String]
      def binwrite(id, contents)
        path.join(id).binwrite(contents)
      end

      # @param id [Pathname, #to_s]
      def delete(id)
        path.join(id).delete
      end

      private

      # @return [Pathname]
      def path_for(name)
        path.join(name.to_s)
      end
    end
  end
end
