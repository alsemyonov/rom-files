# frozen_string_literal: true

require 'rom/schema'
require 'rom/schema/inferrer'
require_relative '../attribute'
require_relative 'attributes_inferrer'

module ROM
  module Files
    class Schema < ROM::Schema
      class Inferrer < ROM::Schema::Inferrer
        # @!attribute [r] attributes_inferrer
        #   @return [Array(Array, Array)]
        attributes_inferrer ->(schema, gateway, options) do
          dataset = gateway.dataset(schema.name.dataset)
          inferrer = if dataset.mime_type
                       if AttributesInferrer.registered?(content_type = dataset.mime_type.content_type)
                         AttributesInferrer[content_type].with(options)
                       elsif AttributesInferrer.registered?(media_type = dataset.mime_type.media_type)
                         AttributesInferrer[media_type].with(options)
                       else
                         AttributesInferrer.new(**options)
                       end
                     else
                       AttributesInferrer.new(**options)
                     end
          inferrer.(schema, gateway)
        end

        # @!attribute [r] attr_class
        #   @return [Class]
        attr_class Files::Attribute
      end
    end
  end
end
