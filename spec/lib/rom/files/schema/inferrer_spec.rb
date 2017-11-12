# frozen_string_literal: true

require 'rom/files/schema/inferrer'
require 'shared/rom/files/media_files'

RSpec.describe ROM::Files::Schema::Inferrer do
  include_context 'media files'

  subject(:inferrer) { described_class.new }
  let(:relation_name) { ROM::Relation::Name.new(:media) }
  let(:schema) { ROM::Schema.new(relation_name) }

  its(:attr_class) { is_expected.to eq ROM::Files::Attribute }

  describe '#call' do
    subject(:result) { inferrer.(schema, gateway) }

    it { is_expected.to be_a Hash }
    its([:attributes]) { is_expected.to be_a Array }

    describe '[:attributes]' do
      subject(:attributes) { result[:attributes] }

      it { is_expected.to be_a Array }
      its(:size) { is_expected.to eq 1 }
      its(:first) { is_expected.to be_a ROM::Files::Attribute }
    end
  end
end
