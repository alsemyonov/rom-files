# frozen_string_literal: true

require 'bundler'
Bundler.setup
require 'rspec/its'
require 'simplecov'

require 'rom-files'

SPEC_ROOT = Pathname(__dir__)
