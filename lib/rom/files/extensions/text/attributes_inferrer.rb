# frozen_string_literal: true

require 'rom/files/schema/attributes_inferrer'

module ROM
  module Files
    module Text
      class AttributesInferrer < Schema::AttributesInferrer
        def infer_attributes(schema, _gateway)
          [
            build(Types::Path, ID, schema),
            build(Types::String.meta(__contents__: true), :__contents__, schema)
          ]
        end

        def columns
          super + [:__contents__]
        end
      end
    end

    Schema::AttributesInferrer.register 'text/plain', Text::AttributesInferrer.new.freeze
  end
end
