# frozen_string_literal: true

require 'rom/types'
require 'rom/files/types'
require 'rubygems/version'

module ROM
  module Files
    module Types
      module Gem
        Name = Types::String
        Version = Types.Definition(::Gem::Version, ::Gem::Version.method(:create))
        Requirement = Types.Definition(::Gem::Requirement, ::Gem::Requirement.method(:create))
        Requirements = Types::Array.of(Requirement).constructor do |value|
          value = value.split(/,\s*/) if value.is_a?(String)
          value
        end
        Dependency = Types::Array.constructor do |value|
          name, requirements = value.split(' ', 2)
          result = [Name[name]]
          result += Requirements[requirements] if requirements
          result
        end
      end
    end
  end
end
