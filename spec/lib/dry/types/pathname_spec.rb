# frozen_string_literal: true

require 'dry/types/pathname'

RSpec.describe Dry::Types do
  subject(:types) { described_class }
  specify { expect(types['optional.pathname']).to be_a Dry::Types::Sum }

  describe 'pathname' do
    subject(:type) { types['pathname'] }

    it { is_expected.to be_a Dry::Types::Definition }

    specify { expect(type[nil]).to eq nil }
    specify { expect(type['sample.rb']).to eq 'sample.rb' }
    specify { expect(type[Pathname('sample.rb')]).to eq Pathname('sample.rb') }
  end

  describe 'optional.pathname' do
    subject(:type) { types['optional.pathname'] }

    it { is_expected.to be_a Dry::Types::Sum }

    specify { expect(type[nil]).to eq nil }
    specify { expect(type['sample.rb']).to eq 'sample.rb' }
    specify { expect(type[Pathname('sample.rb')]).to eq Pathname('sample.rb') }
  end

  describe 'coercible.pathname' do
    subject(:type) { types['coercible.pathname'] }

    it { is_expected.to be_a Dry::Types::Definition }

    specify { expect(type[nil]).to eq Pathname('') }
    specify { expect(type[:media]).to eq Pathname('media') }
    specify { expect(type['sample.rb']).to eq Pathname('sample.rb') }
    specify { expect(type[Pathname('sample.rb')]).to eq Pathname('sample.rb') }
  end

  describe 'strict.pathname' do
    subject(:type) { types['strict.pathname'] }

    it { is_expected.to be_a Dry::Types::Constrained }

    specify { expect { type[nil] }.to raise_error Dry::Types::ConstraintError }
    specify { expect { type['sample.rb'] }.to raise_error Dry::Types::ConstraintError }
    specify { expect { type[Pathname('sample.rb')] }.not_to raise_error }
    specify { expect(type[Pathname('sample.rb')]).to eq Pathname('sample.rb') }
  end
end
