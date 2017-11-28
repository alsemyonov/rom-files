# frozen_string_literal: true

module ROM
  module Files
    module Extensions
      module Gem
        module Relations
          class Specifications < ROM::Files::Relation
            dataset { select('*_spec.rb').recursive.inside('spec') }

            schema 'application/x-ruby', as: :specifications, infer: true do
              use :stat

              attribute :specification_path, Types::Path
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
end
