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
                        Dataset.new(path, mime_type: types.first)
                      else
                        Dataset.new(path_for(name))
                      end
      end

      # @return [Boolean]
      def key?(name)
        MIME::Types[name].any? || path_for(name).exist?
      end

      private

      # @return [Pathname]
      def path_for(name)
        path.join(name.to_s)
      end
    end
  end
end
