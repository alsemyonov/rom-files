# frozen_string_literal: true

require 'rom/files/extensions'

module ROM
  module Files
    module Plugins
      module Configuration
        module Gem
          # Provide methods for registering files relations with common gem setup
          #
          # @param configuration [ROM::Configuration]
          # @param relations [Boolean]
          # @return [ROM::Configuration]
          def self.apply(configuration, relations: true)
            configuration.extend Methods
            configuration.register_gem_relations if relations
          end

          module Methods
            def register_gem_relations
              Files.load_extensions(:gem)
              Files::Extensions::Gem.register_extension(self)
            end
          end
        end
      end
    end
  end
end
