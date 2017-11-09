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
      #
      # @!method select_append(*patterns)
      #   @param (see Dataset#select_append)
      #   @return [Relation]
      #
      # @!method reject(*patterns)
      #   @param (see Dataset#reject)
      #   @return [Relation]
      #
      # @!method reject_append(*patterns)
      #   @param (see Dataset#reject_append)
      #   @return [Relation]
      #
      # @!method inside(*prefixes)
      #   @param (see Dataset#inside)
      #   @return [Relation]
      #
      # @!method recursive
      #   @return [Relation]
      #
      # @!method recursive?
      #   @return [Boolean]
      #
      # @!method sort(sorting = :to_s)
      #   @param (see Dataset#sort)
      #   @return [Relation]
      forward :select, :select_append, :reject, :reject_append,
              :inside, :recursive, :recursive?, :sort

      # @!method mime_type
      #   @return [MIME::Type, nil]
      #
      #   @see Dataset#mime_type
      # @!method pluck
      #   @return [Array]
      #
      #   @see Dataset#pluck
      def_instance_delegators :dataset, :mime_type, :pluck

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
