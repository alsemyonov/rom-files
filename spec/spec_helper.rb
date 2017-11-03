# frozen_string_literal: true

require 'bundler'
Bundler.setup
require 'simplecov'

require 'rom-files'

SPEC_ROOT = Pathname(__FILE__).dirname

RSpec.configure do |config|
  config.before do
    @constants = Object.constants
  end

  config.after do
    added_constants = Object.constants - @constants
    added_constants.each { |name| Object.send(:remove_const, name) }
  end
end
