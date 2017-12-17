# frozen_string_literal: true

module ROM
  module Files
    module Extensions
      module Gem
        module Relations
          class Documentations < ROM::Files::Relation
            dataset { recursively }

            schema 'text/markdown', as: :documentations, infer: true do
            end
          end
        end
      end
    end
  end
end
