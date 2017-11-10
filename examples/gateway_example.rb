#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rom-files'

gateway = ROM::Files::Gateway.new(Pathname(__dir__).dirname)

lib = gateway.dataset(:lib)
spec = gateway.dataset(:spec)

p :lib?, gateway.dataset?(:lib) # true
p :spec?, gateway.dataset?(:spec) # true

p :lib, lib
p :spec, spec

p :implementations, lib.pluck(&:to_s)
p :specifications, spec.pluck(&:to_s)
