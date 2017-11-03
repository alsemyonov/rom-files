#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rom-files'

# @return [ROM::Container]
def gem_container(path = Pathname(__dir__).dirname)
  ROM.container(:files, path) do |config|
    config.relation(:docs) {}
    config.relation(:bin) {}
    config.relation(:examples) {}
    config.relation :lib do
      dataset { select '**/*.rb' }
    end
    config.relation :spec do
      dataset { select '**/*_spec.rb' }
    end
  end
end

@container = gem_container
class << self
  attr_reader :container
end

require 'pry'
binding.pry
