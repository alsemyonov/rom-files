# frozen_string_literal: true

require 'rom/files/dataset'
require 'concurrent/hash'

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

      # @return [Dataset]
      def create_dataset(name)
        @data[name] = Dataset.new(path_for(name))
      end

      # @return [Boolean]
      def key?(name)
        path_for(name).exist?
      end

      private

      # @return [Pathname]
      def path_for(name)
        path.join(name.to_s)
      end
    end
  end
end
