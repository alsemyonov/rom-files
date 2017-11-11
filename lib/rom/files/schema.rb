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
      # if it includes attributes from other relations etc.
      #
      # Default implementation is a no-op and it simply returns back untouched relation
      #
      # @param [Relation] relation
      #
      # @return [Relation]
      #
      # @api public
      def call(relation)
        relation.new(relation.dataset.with(row_proc: row_proc), schema: self)
      end

      # @return [Method, Proc]
      def row_proc
        method(:load_attributes)
      end

      # @param pathname [Pathname]
      # @return [Hash{Symbol => Object}]
      def load_attributes(pathname)
        attributes.each_with_object({}) do |attribute, result|
          result[attribute.name] = attribute.(pathname)
          result
        end
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
