# frozen_string_literal: true

require 'dry/core/extensions'

module ROM
  module Files
    extend Dry::Core::Extensions

    register_extension :text do
      require 'rom/files/extensions/text'
    end
  end
end
