# frozen_string_literal: true

require_relative 'types'
require_relative '../markup/attributes_inferrer'

module ROM
  module Files
    module Markdown
      class AttributesInferrer < Markup::AttributesInferrer
        def markup_type
          Types::Markdown::Document
        end
      end
    end

    Schema::AttributesInferrer.register 'text/markdown', Markdown::AttributesInferrer.new.freeze
  end
end
