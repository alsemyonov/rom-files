# frozen_string_literal: true

module ROM
  module Files
    module Gem
      module Relations
        class Documentations < ROM::Files::Relation
          gateway :files

          dataset { recursive }

          schema 'text/markdown', as: :documentations, infer: true do
          end
        end
      end
    end
  end
end
