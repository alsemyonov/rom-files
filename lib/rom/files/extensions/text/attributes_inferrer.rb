# frozen_string_literal: true

require 'rom/files/schema/attributes_inferrer'

module ROM
  module Files
    module Text
      class AttributesInferrer < Schema::AttributesInferrer
        def infer_attributes(schema, gateway)
          super + infer_data_attributes(schema, gateway)
        end

        def infer_data_attributes(schema, _gateway)
          [
            build(data_type.meta(DATA: true), DATA, schema)
          ]
        end

        # @return [Dry::Types::Definition]
        def data_type
          Types::String
        end

        def columns
          super + [DATA]
        end
      end
    end

    Schema::AttributesInferrer.register 'text/plain', Text::AttributesInferrer.new.freeze
  end
end
