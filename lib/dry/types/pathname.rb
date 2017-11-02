# frozen_string_literal: true

require 'dry-types'
require 'dry/types/core'
require 'pathname'

module Dry
  module Types
    register 'pathname', simple = Definition[Pathname].new(Pathname)
    register 'strict.pathname', strict = simple.constrained(type: Pathname)
    register 'coercible.pathname',
             coercible = simple.constructor(Kernel.method(:Pathname))
    register 'optional.strict.pathname', strict.optional
    register 'optional.coercible.pathname', coercible.optional
  end
end
