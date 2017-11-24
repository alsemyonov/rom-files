# frozen_string_literal: true

require 'kramdown'
require 'rom/files/types'

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
  end
end
