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
      # if it uncludes attributes from other relations etc.
      #
      # Default implementation is a no-op and it simply returns back untouched relation
      #
      # @param [Relation] relation
      #
      # @return [Relation]
      #
      # @api public
      def call(relation)
        relation.class.new(relation.dataset.with(row_proc: method(:load_attributes)))
      end

      def load_attributes(row_proc)
        each do |attribute|
          row_proc[attribute.name] = attribute.call(row_proc[:__FILE__])
        end
      end
    end
  end
end
