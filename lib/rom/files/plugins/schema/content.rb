# frozen_string_literal: true

require 'rom/files/constants'
require 'rom/files/types'
require 'rom/schema/dsl'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for automatically adding contents of file
        # to the schema definition
        #
        # @example Generic `DATA` field with String type
        #   schema do
        #     use :content
        #   end
        #
        # @example Specify another type
        #   schema do
        #     use :content, type: Types::YAML
        #   end
        #
        # @example Specify another name
        #   # using other types
        #   schema do
        #     use :content, name: :content
        #   end
        #
        # @api public
        module Content
          NAME = Files::DATA
          TYPE = Types::String

          # @api private
          def self.apply(schema, name: NAME, type: TYPE, content_schema: EMPTY_ARRAY)
            contents = type.meta(name: name, source: schema.name, DATA => true)
            content_schema = content_schema.map do |attr|
              attr.meta(content: true)
            end

            schema.attributes.concat(
              schema.class.attributes([contents, *content_schema], schema.attr_class)
            )
          end

          # @api private
          module DSL
            # Sets non-default contents attribute
            #
            # @example Set custom attribute name
            #   schema do
            #     use :content
            #     contents :content
            #   end
            #
            # @example Set custom type
            #   schema do
            #     use :content
            #     contents type: Types::JSON
            #   end
            #
            # @api public
            def contents(name = NAME, inline_type = TYPE, type: inline_type, &schema)
              options = plugin_options(:content)
              options[:name] = name
              options[:type] = type
              content_schema(&schema)

              self
            end

            def content_attribute(name, type)
              options = plugin_options(:content)

              (options[:content_schema] ||= []) << type.meta(name: name)
            end

            def content_schema
              ROM::Schema::DSL.new()
            end
          end
        end
      end
    end
  end
end
