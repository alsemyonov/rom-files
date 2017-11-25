# frozen_string_literal: true

module ROM
  module Files
    module Gem
      module Relations
        class Specifications < ROM::Files::Relation
          gateway :files

          dataset { select('*_spec.rb').recursive.inside('spec') }

          schema 'application/x-ruby', as: :specifications, infer: true do
            use :stat

            attribute :implementation_path, Types.ForeignKey(
              :implementations,
              map: ->(path) { path.pathmap('%{^spec,}X.rb') }
            )

            associations do
              has_one :implementation, foreign_key: :implementation_path
            end
          end
        end
      end
    end
  end
end
