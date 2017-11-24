# frozen_string_literal: true

require 'rom/files/schema/attributes_inferrer'

module ROM
  module Files
    module Markup
      class AttributesInferrer < Schema::AttributesInferrer
        def infer_attributes(schema, gateway)
          super + infer_markup_attributes(schema, gateway)
        end

        def infer_markup_attributes(schema, _gateway)
          [
            build(markup_type.meta(DATA: true), DATA, schema)
          ]
        end

        # @return [Dry::Types::Definition]
        def markup_type
          raise NotImplementedError, "#{self.class}#markup_type is not implemented"
        end

        def columns
          super + [DATA]
        end
      end
    end
  end
end
