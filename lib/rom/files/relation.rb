# frozen_string_literal: true

require 'forwardable'
require 'rom/relation'
require_relative 'attribute'
require_relative 'schema'
require_relative 'schema/inferrer'

module ROM
  module Files
    class Relation < ROM::Relation
      extend Forwardable
      include Enumerable
      include Files

      adapter :files
      schema_attr_class Files::Attribute
      schema_class Files::Schema
      schema_inferrer Files::Schema::Inferrer.new.freeze

      def initialize(*) # :nodoc:
        super
        @dataset = schema.dataset_for(self) if schema
      end

      # @!attribute [r] dataset
      #   @return [Files::Dataset]
      # @!attribute [r] schema
      #   @return [Files::Schema]

      # @!group Reading

      # @!method select(*patterns)
      #   @param (see Dataset#select)
      #   @return [Relation]
      #
      # @!method select_append(*patterns)
      #   @param (see Dataset#select_append)
      #   @return [Relation]
      #
      # @!method inside(*prefixes)
      #   @param (see Dataset#inside)
      #   @return [Relation]
      #
      # @!method recursively
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
      # @!method sort(sorting = :to_s)
      #   @param (see Dataset#sort)
      #   @return [Relation]
      #
      # @!method restrict(criteria = nil)
      #   @param (see Dataset#restrict)
      #   @return [Relation]
      #
      # @!method join(*args)
      #   @param (see Dataset#join)
      #   @return [Relation]
      forward :select, :select_append, :reject, :reject_append, :inside, :recursively,
              :sort,
              :restrict, :join,
              :files, :directories,
              :at, :dig, :up

      # @!method path
      #   @return [Pathname]
      #
      #   @see Dataset#path
      #
      # @!method mime_type
      #   @return [MIME::Type, nil]
      #
      #   @see Dataset#mime_type
      #
      # @!method pluck
      #   @return [Array]
      #
      #   @see Dataset#pluck
      #
      # @!method recursive?
      #   @return [Boolean]
      #
      #   @see Dataset#recursively?
      def_instance_delegators :dataset, :path, :mime_type, :recursive?, :pluck

      # Project a relation with provided attribute names
      #
      # @param names [Array<Symbol>] A list with attribute names
      #
      # @return [Relation]
      #
      # @api public
      def project(*names)
        schema.project(*names).(self)
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

      # @!group Writing

      def create(tuple)
        dataset.write(
          identify(tuple),
          contents_for(tuple)
        )
      end
      alias << create

      def update(tuple, attributes = {})
        dataset.write(
          identify(tuple),
          contents_for(tuple.merge(attributes))
        )
      end

      def delete(tuple)
        dataset.delete(identify(tuple))
      end

      # @!method identify(tuple)
      #   @param (see Schema#identify)
      #   @return (see Schema#identify)
      #   @see Schema#identify
      #
      # @!method contents_for(tuple)
      #   @param (see Schema#contents_for)
      #   @return (see Schema#contents_for)
      #   @see Schema#contents_for
      def_instance_delegators :schema, :identify, :contents_for
    end
  end
end
