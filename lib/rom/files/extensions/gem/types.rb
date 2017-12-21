# frozen_string_literal: true

require 'rom/types'
require 'rom/files/types'
require 'rubygems/version'

module ROM
  module Files
    module Types
      module Gem
        Version = Dry::Types::Definition[::Gem::Version].new(::Gem::Version).constructor do |value|
          ::Gem::Version.create(value)
        end
      end
    end
  end
end
