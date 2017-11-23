#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rom-files'
require 'rspec'

RSpec.describe ROM::Files::Gateway, 'usage' do
  subject(:gateway) { ROM::Files::Gateway.new(uri) }
  let(:uri) { SPEC_ROOT.dirname }

  example 'Obtaining datasets', :aggregate_failures do
    lib = gateway.dataset(:lib).recursive

    expect(lib).to be_a ROM::Files::Dataset
    expect(gateway.dataset?(:lib)).to be true

    puts "Library files:\n", lib.pluck(&:to_s)

    spec = gateway.dataset(:spec).recursive

    expect(spec).to be_a ROM::Files::Dataset
    expect(gateway.dataset?(:spec)).to be true

    p "Specifications:\n", spec.pluck(&:to_s)
  end
end

require 'rspec/autorun' if $PROGRAM_NAME == __FILE__
