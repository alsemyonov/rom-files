# frozen_string_literal: true

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
          # @api private
          def self.apply(schema, name: :__contents__, type: Types::String)
            contents_attribute = type.meta(name: name, source: schema.name)

            schema.attributes.concat(
              schema.class.attributes([contents_attribute], schema.attr_class)
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
            def contents_attribute(name, type = Types::String)
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
