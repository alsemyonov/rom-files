# frozen_string_literal: true

require 'rom/files/types'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for automatically adding contents of file
        # to the schema definition
        #
        # @example Generic `__contents__` field with String type
        #   schema do
        #     use :contents
        #   end
        #
        # @example Specify another type
        #   schema do
        #     use :contents, type: Types::YAML
        #   end
        #
        # @example Specify another name
        #   # using other types
        #   schema do
        #     use :contents, name: :contents
        #   end
        #
        # @api public
        module Contents
          DEFAULT_NAME = :__contents__
          DEFAULT_TYPE = Types::String

          # @api private
          def self.apply(schema, name: DEFAULT_NAME, type: DEFAULT_TYPE)
            contents = type.meta(name: name, source: schema.name, __contents__: true)

            schema.attributes.concat(
              schema.class.attributes([contents], schema.attr_class)
            )
          end

          # @api private
          module DSL
            # Sets non-default contents attribute
            #
            # @example
            #   schema do
            #     use :contents
            #     contents_attribute :create_on, :updated_on
            #   end
            #
            # @api public
            def contents_attribute(name = DEFAULT_NAME, type = DEFAULT_TYPE)
              options = plugin_options(:contents)
              options[:name] = name
              options[:type] = type

              self
            end
          end
        end
      end
    end
  end
end
