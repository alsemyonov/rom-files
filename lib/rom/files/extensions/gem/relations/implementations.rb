# frozen_string_literal: true

module ROM
  module Files
    module Extensions
      module Gem
        module Relations
          class Implementations < ROM::Files::Relation
            dataset { recursively.inside('lib') }

            schema 'application/x-ruby', as: :implementations, infer: true do
              use :stat

              attribute :implementation_path, Types::Path
              attribute :specification_path, Types.ForeignKey(
                :specifications,
                map: ->(path) { path.pathmap('spec/%X_spec.rb') }
              )

              associations do
                has_one :specification, foreign_key: :specification_path
              end
            end
          end
        end
      end
    end
  end
end
