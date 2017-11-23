# frozen_string_literal: true

require 'dry/core/extensions'

module ROM
  module Files
    extend Dry::Core::Extensions

    register_extension :text do
      require 'rom/files/extensions/text'
    end

    register_extension :markdown do
      require 'rom/files/extensions/markdown'
    end
  end
end
