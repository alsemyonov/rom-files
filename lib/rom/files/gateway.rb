# frozen_string_literal: true

require 'rom/files/connection'
require 'forwardable'

module ROM
  module Files
    # Files gateway interface
    #
    # @example
    #   gateway = ROM::Files::Gateway.new('.')
    #   gateway.dataset(:lib)
    #   gateway[:lib].insert(name: 'rom.rb')
    #
    # @api public
    class Gateway < ROM::Gateway
      extend Forwardable

      adapter :files

      # @!attribute [r] connection
      #   @return [Connection]

      # @param root [Pathname, #to_s]
      def initialize(root)
        @connection = Connection.new(File.absolute_path(root))
      end

      # @return [Object] default logger
      #
      # @api public
      attr_reader :logger

      # Set default logger for the gateway
      #
      # @param logger [Logger] object
      #
      # @api public
      def use_logger(logger)
        @logger = logger
      end

      # @param name [Pathname, #to_s]
      # @return [Dataset]
      def dataset(name)
        self[name] || connection.create_dataset(name)
      end

      # @!method []
      #   @param (see Connection#[])
      #   @return (see Connection#[])
      def_instance_delegators :connection, :[]

      # @!method dataset?
      #   @param (see Connection#key?)
      #   @return (see Connection#key?)
      def_instance_delegator :connection, :key?, :dataset?
    end
  end
end
