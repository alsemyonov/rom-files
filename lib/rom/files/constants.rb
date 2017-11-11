# frozen_string_literal: true

require 'dry/core/constants'

module ROM
  module Files
    include Dry::Core::Constants

    ID = :__FILE__
    DATA = :DATA
    ALL = ['*'].freeze
    DIRS = %w[. ..].freeze
    RECURSIVE_PATTERN = '**/'
    RECURSIVE_EXPRESSION = /#{Regexp.escape(RECURSIVE_PATTERN)}/
  end
end
