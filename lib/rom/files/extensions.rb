# frozen_string_literal: true

require 'dry/core/extensions'

module ROM
  module Files
    extend Dry::Core::Extensions

    register_extension :text do
      require_relative 'extensions/text/attributes_inferrer'
    end

    register_extension :markdown do
      require_relative 'extensions/markdown/attributes_inferrer'
    end

    register_extension :ruby do
      require_relative 'extensions/ruby/attributes_inferrer'
    end
  end
end
