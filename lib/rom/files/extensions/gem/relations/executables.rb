# frozen_string_literal: true

module ROM
  module Files
    module Extensions
      module Gem
        module Relations
          class Executables < ROM::Files::Relation
            gateway :files

            dataset { inside('exe') }

            schema '.', as: :executables, infer: true do
              use :shebang
              use :contents, type: ROM::Files::Types::Ruby::ASTWithComments
            end
          end
        end
      end
    end
  end
end
