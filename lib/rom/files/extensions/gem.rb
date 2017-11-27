# frozen_string_literal: true

require_relative 'gem/relations/documentations'
require_relative 'gem/relations/executables'
require_relative 'gem/relations/implementations'
require_relative 'gem/relations/specifications'

module ROM
  module Files
    module Extensions
      module Gem
        # @param config [ROM::Configuration]
        def self.register_extension(config)
          config.register_relation Relations::Documentations,
                                   Relations::Executables,
                                   Relations::Implementations,
                                   Relations::Specifications
        end
      end
    end
  end
end
