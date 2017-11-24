# frozen_string_literal: true

require 'rom/files/constants'
require 'rom/files/types'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for automatically adding shebang of file
        # to the schema definition
        #
        # @example Generic `DATA` field with String type
        #   schema do
        #     use :shebang
        #   end
        #
        # @example Specify another type
        #   schema do
        #     use :shebang, type: Types::YAML
        #   end
        #
        # @example Specify another name
        #   # using other types
        #   schema do
        #     use :shebang, name: :shebang
        #   end
        #
        # @api public
        module Shebang
          TYPE = Types::String
          NAME = :run_with

          # @param path [Pathname]
          # @return [String, nil]
          def self.read_shebang(path)
            shebang = path.readlines.first || ''
            shebang[2..-1].chomp if shebang.match?(/\A#!/)
          end

          # @api private
          def self.apply(schema, name: NAME, type: TYPE)
            shebang = type.meta(name: name, source: schema.name, __proc__: method(:read_shebang))

            schema.attributes.concat(
              schema.class.attributes([shebang], schema.attr_class)
            )
          end

          # @api private
          module DSL
            # Sets non-default shebang attribute
            #
            # @example Set custom attribute name
            #   schema do
            #     use :shebang
            #     shebang :shebang
            #   end
            #
            # @example Set custom type
            #   schema do
            #     use :shebang
            #     shebang type: Types::JSON
            #   end
            #
            # @api public
            def shebang(name = NAME, inline = TYPE, type: inline)
              options = plugin_options(:shebang)
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
