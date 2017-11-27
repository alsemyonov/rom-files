# frozen_string_literal: true

require_relative 'types'
require_relative '../markup/attributes_inferrer'

module ROM
  module Files
    module Extensions
      module Ruby
        class AttributesInferrer < Markup::AttributesInferrer
          # @return [Dry::Types::Definition]
          def markup_type
            Types::Ruby::ASTWithComments
          end
        end
      end
    end

    Schema::AttributesInferrer.register 'application/x-ruby', Extensions::Ruby::AttributesInferrer.new.freeze
  end
end
