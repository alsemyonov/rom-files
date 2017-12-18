# frozen_string_literal: true

require 'rom/files/types'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for automatically adding properties of pathname
        # to the schema definition
        #
        # @example Generic `__props__` field with String type
        #   schema do
        #     use :properties
        #   end
        #
        # @example Specify set of properties to provide
        #   schema do
        #     use :properties, names: %i[basename extname]
        #   end
        #
        # @api public
        module Properties
          TYPE = Types::Pathname
          MAP = Hash.new do |map, key|
            map[key] = TYPE
          end.merge(
            atime: Types::Time,
            # basename: Types::Pathname,
            birthtime: Types::Time,
            cleanpath: Types::Time,
            ctime: Types::Time,
            # dirname: Types::Pathname,
            # extname: Types::Pathname
          )

          class << self
            # @api private
            def apply(schema, properties: EMPTY_ARRAY, names: EMPTY_ARRAY)
              properties += names.map { |name| MAP[name].meta(name: name, __proc__: name) }
              attributes = properties.map { |property| property.meta(source: schema.name) }
              schema.attributes.concat(schema.class.attributes(attributes, schema.attr_class))
            end
          end

          # @api private
          module DSL
            # @example Set properties from Pathname
            #   schema do
            #     use :properties
            #
            #     property :basename
            #     property :dirname, Types::Pathname
            #     property :birthtime
            #     property :atime, as: :accesstime
            #   end
            #
            # @api public
            def property(property, type = MAP[property], as: property)
              options = plugin_options(:properties)
              (options[:properties] ||= []) << type.meta(name: as, __proc__: property)

              self
            end
          end
        end
      end
    end
  end
end
