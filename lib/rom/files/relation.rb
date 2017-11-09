# frozen_string_literal: true

require 'forwardable'
require 'rom/relation'
require_relative 'schema'

module ROM
  module Files
    class Relation < ROM::Relation
      extend Forwardable
      include Enumerable
      include Files

      adapter :files
      schema_class Files::Schema

      # @!attribute [r] dataset
      #   @return [Dataset]

      # @!group Reading

      # @!method select(*patterns)
      #   @param (see Dataset#select)
      #   @return [Relation]
      # @!method select_append(*patterns)
      #   @param (see Dataset#select_append)
      #   @return [Relation]
      # @!method reject(*patterns)
      #   @param (see Dataset#reject)
      #   @return [Relation]
      # @!method reject_append(*patterns)
      #   @param (see Dataset#reject_append)
      #   @return [Relation]
      # @!method inside(*prefixes)
      #   @param (see Dataset#inside)
      #   @return [Relation]
      # @!method recursive
      #   @return [Relation]
      # @!method recursive?
      #   @return [Boolean]
      # @!method sort(sorting = :to_s)
      #   @param (see Dataset#sort)
      #   @return [Relation]
      forward :select, :select_append, :reject, :reject_append,
              :inside, :recursive, :recursive?, :sort

      # @!method mime_type
      #   @return [MIME::Type, nil]
      def_instance_delegators :dataset, :mime_type

      # Pluck values from a specific column
      #
      # @example
      #   users.pluck { |pathname| pathname.basename.to_s }
      #   # [1, 2, 3]
      #
      # @example
      #   users.pluck(:id)
      #   # [1, 2, 3]
      #
      # @param [Symbol] key An optional name of the key for extracting values
      #                     from tuples
      #
      # @return [Array]
      #
      # @api public
      def pluck(key = nil, &block)
        block ||= key.to_proc
        dataset.pluck(&block)
      end

      # Return relation count
      #
      # @example
      #   users.count
      #   # => 12
      #
      # @return [Integer]
      #
      # @api public
      def count
        dataset.count
      end
    end
  end
end
