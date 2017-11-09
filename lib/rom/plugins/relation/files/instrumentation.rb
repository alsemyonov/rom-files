# frozen_string_literal: true

require 'rom/plugins/relation/instrumentation'

module ROM
  module Plugins
    module Relation
      module Files
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

ROM.plugins do
  adapter :files do
    register :instrumentation, ROM::Plugins::Relation::Files::Instrumentation, type: :relation
  end
end
