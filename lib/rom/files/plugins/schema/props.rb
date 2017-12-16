# frozen_string_literal: true

require 'rom/files/types'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for automatically adding props properties of file
        # to the schema definition
        #
        # @example Generic `__props__` field with String type
        #   schema do
        #     use :props
        #   end
        #
        # @example Specify another set of properties
        #   schema do
        #     use :props, properties: %i[]
        #   end
        #
        # @api public
        module Props
          class << self
            # @api private
            def apply(schema, names: EMPTY_ARRAY, type: Types::Pathname, **aliases)
              attributes = names.map do |name|
                build_property(schema, name, type: type)
              end
              attributes += aliases.map do |name, property|
                build_property(schema, name, prop: property)
              end

              schema.attributes.concat(
                schema.class.attributes(attributes, schema.attr_class)
              )
            end

            private

            def build_property(schema, name, property: name, type: TYPES[props])
              raise ArgumentError, "Unknown property #{(props || name).inspect}" unless type
              type.meta(name: name, source: schema.name, __proc__: property.to_proc)
            end
          end

          # @api private
          module DSL
            # @example Sets non-default list of props properties
            #   schema do
            #     use :props
            #     props :basename, basename: :name
            #   end
            #
            # @example Sets list of aliased properties
            #   schema do
            #     use :props
            #     props aliased: { created_at: :ctime }
            #   end
            #
            # @api public
            def prop(names = NAME, aliases: EMPTY_HASH)
              options = plugin_options(:props)
              options[:names] += names
              options[:props] = props
              options[:aliases] = aliases

              self
            end
          end
        end
      end
    end
  end
end
