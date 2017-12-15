# frozen_string_literal: true

require 'dry/core/constants'

module ROM
  module Files
    include Dry::Core::Constants

    ID = :path
    DATA = :DATA
    HERE = %w[.].freeze
    ALL = %w[*].freeze
    FILES = %w[file].freeze
    DIRECTORIES = %w[directory].freeze
    RECURSIVE_PATTERN = '**'
    RECURSIVE_EXPRESSION = /#{Regexp.escape(RECURSIVE_PATTERN)}/
  end
end
