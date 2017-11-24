# frozen_string_literal: true

require_relative '../markup/attributes_inferrer'

module ROM
  module Files
    module Text
      class AttributesInferrer < Markup::AttributesInferrer
        # @return [Dry::Types::Definition]
        def markup_type
          Types::String
        end
      end
    end

    Schema::AttributesInferrer.register 'text/plain', Text::AttributesInferrer.new.freeze
  end
end
