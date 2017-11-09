# frozen_string_literal: true

require 'rom/files/types'

RSpec.describe ROM::Files::Types::Path do
  subject(:type) { described_class }

  its([Pathname.pwd]) { is_expected.to be_a Pathname }
  its(:meta) { is_expected.to eq(primary_key: true) }
end
