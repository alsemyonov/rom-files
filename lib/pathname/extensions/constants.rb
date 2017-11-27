# frozen_string_literal: true

require 'pathname/extensions'
require 'dry/core/constants'

class Pathname
  include Dry::Core::Constants

  HERE = Pathname('.').freeze
  UPPER = Pathname('..').freeze
  ROOT = Pathname('/').freeze
end
