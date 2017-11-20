# frozen_string_literal: true

require 'rom/files/constants'
require 'rom/files/types'
require 'mime/types/full'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for obtaining MIME-type of file using its name
        #
        # @example Generic `mime_type` field
        #   schema do
        #     use :mime_type
        #   end
        #
        # @api public
        module Mime
          PROC = ->(path) { MIME::Types.type_for(path.basename.to_s).first }
          TYPE = Types::MimeType.optional

          # @api private
          def self.apply(schema, name: :mime_type, type: TYPE)
            mime_type = type.meta(
              name: name,
              __proc__: PROC,
              source: schema.name
            )

            schema.attributes.concat(
              schema.class.attributes([mime_type], schema.attr_class)
            )
          end

          # @api private
          module DSL
            # Sets non-default contents attribute
            #
            # @example Set custom attribute name `#type` for MIME-type
            #   schema do
            #     use :mime
            #     mime :type
            #   end
            #
            # @api public
            def mime(name = :mime_type, inline_type = TYPE, type: inline_type)
              options = plugin_options(:mime)
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
