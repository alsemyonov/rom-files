# frozen_string_literal: true

require 'kramdown'
require 'rom/files/types'
require_relative '../text/attributes_inferrer'

module ROM
  module Files
    module Types
      module Markdown
        KDocument = ::Kramdown::Document

        Document = Dry::Types::Definition[KDocument].new(KDocument).constructor do |doc|
          doc.is_a?(KDocument) ? doc : KDocument.new(doc)
        end
      end
    end

    module Markdown
      class AttributesInferrer < Text::AttributesInferrer
        def data_type
          Types::Markdown::Document
        end
      end
    end

    Schema::AttributesInferrer.register 'text/markdown', Markdown::AttributesInferrer.new.freeze
  end
end
