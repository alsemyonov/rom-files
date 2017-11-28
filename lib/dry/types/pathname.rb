# frozen_string_literal: true

require 'dry-types'
require 'dry/types/core'
require 'pathname'

module Dry
  module Types
    def self.register_if_needed(key, value)
      register(key, value) unless registered?(key)
    end

    def self.Pathname(path)
      path.is_a?(Pathname) ? path : Kernel::Pathname(path.to_s)
    end

    register_if_needed 'pathname', simple = Definition[Pathname].new(Pathname)
    register_if_needed 'strict.pathname', strict = simple.constrained(type: Pathname)
    register_if_needed 'coercible.pathname',
                       coercible = simple.constructor(method(:Pathname))
    register_if_needed 'optional.pathname', simple.optional
    register_if_needed 'optional.strict.pathname', strict.optional
    register_if_needed 'optional.coercible.pathname', coercible.optional
  end
end
