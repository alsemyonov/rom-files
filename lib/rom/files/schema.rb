# frozen_string_literal: true

require 'rom/schema'
require_relative 'types'
require_relative 'associations'

module ROM
  module Files
    # Specialized schema for files adapter
    #
    # @api public
    class Schema < ROM::Schema
      # Abstract method for creating a new relation based on schema definition
      #
      # This can be used by views to generate a new relation automatically.
      # In example a schema can project a relation, join any additional relations
      # if it include_patterns attributes from other relations etc.
      #
      # Default implementation is a no-op and it simply returns back untouched relation
      #
      # @param [Relation] relation
      #
      # @return [Relation]
      #
      # @api public
      def call(relation)
        relation.new(dataset_for(relation), schema: self)
      end

      # @param relation [ROM::Files::Relation]
      # @return [Dataset]
      def dataset_for(relation)
        dataset = relation.dataset
        dataset.with(row_proc: ->(pathname) { fulfill(pathname, root: dataset.path) })
      end

      # @param pathname [Pathname]
      # @return [Hash{Symbol => Object}]
      def fulfill(pathname, root:, tuple: {}) # rubocop:disable Metrics/AbcSize
        pathname = root.join(pathname)
        properties.each { |attr| tuple[attr.name] = attr.(pathname, root: root) }
        if data_attribute
          content = tuple[data_attribute.name]
          contents.each { |attr| tuple[attr.name] = attr.(content[attr.name.to_s]) }
        end
        tuple
      end

      # @return [Attribute]
      def data_attribute
        attributes.detect(&:data?)
      end

      # @return [<Attribute>]
      def contents
        attributes.select(&:content?)
      end

      # @return [<Attribute>]
      def properties
        attributes.reject(&:content?)
      end

      # @param tuple [Hash]
      # @return [Pathname]
      def identify(tuple)
        path = (primary_key_names || [ID]).map do |name|
          tuple[name]
        end.compact
        return unless path.any?
        Pathname(path.shift).join(*path)
      end

      # @param tuple [Hash]
      # @return [String]
      def contents_for(tuple)
        contents = attributes.each_with_object([]) do |attr, result|
          result << tuple[attr.name] if attr.meta[DATA]
        end.compact
        contents.join if contents.any?
      end

      # Internal hook used during setup process
      #
      # @see Schema#finalize_associations!
      #
      # @api private
      def finalize_associations!(relations:)
        super do
          associations.map do |definition|
            Files::Associations.const_get(definition.type).new(definition, relations)
          end
        end
      end
    end
  end
end
