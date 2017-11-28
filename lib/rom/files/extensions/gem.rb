# frozen_string_literal: true

require 'rom/files/extensions'
require_relative 'gem/relations/documentations'
require_relative 'gem/relations/executables'
require_relative 'gem/relations/implementations'
require_relative 'gem/relations/specifications'

module ROM
  module Files
    load_extensions :ruby, :markdown

    module Extensions
      module Gem
        # @param config [ROM::Configuration]
        def self.register_extension(config, gateway = :default)
          relations = [Relations::Documentations,
                       Relations::Executables,
                       Relations::Implementations,
                       Relations::Specifications]
          relations.map do |relation|
            relation.gateway gateway
          end
          config.register_relation(*relations)
        end
      end
    end
  end
end
