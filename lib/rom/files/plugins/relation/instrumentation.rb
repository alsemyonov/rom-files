# frozen_string_literal: true

require 'rom/plugins/relation/instrumentation'

module ROM
  module Files
    module Plugins
      module Relation
        # @api private
        module Instrumentation
          def self.included(klass)
            super

            klass.class_eval do
              include ROM::Plugins::Relation::Instrumentation

              # @api private
              # @param [ROM::Files::Relation] relation
              def notification_payload(relation)
                super.merge(**relation.dataset.options)
              end
            end
          end
        end
      end
    end
  end
end
