# frozen_string_literal: true

require 'rom/schema'
require 'rom/schema/dsl'
require_relative '../attribute'
require_relative '../types'

module ROM
  module Files
    class Schema < ROM::Schema
      class DSL < ROM::Schema::DSL
        def contents(name = Files::DATA, inline_type = Types::String, type: inline_type, &schema)
          attribute name, type.meta(DATA => true)
          return unless schema

          contents = DSL.new(relation, **options)
          contents.instance_eval(&schema)
          contents.attributes.map { |attr, attr_type| attributes[attr] = attr_type.meta(content: true) }
        end
      end
    end
  end
end
