# frozen_string_literal: true

require 'rom/files/extensions/text/attributes_inferrer'
require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Extensions::Text::AttributesInferrer do
  include_context 'media files'

  subject(:inferrer) { described_class.new(attr_class: attr_class) }
  let(:attr_class) { ROM::Files::Attribute }

  its(:attr_class) { is_expected.to eq attr_class }

  describe '#call' do
    subject(:result) { inferrer.(schema, gateway) }
    let(:relation_name) { ROM::Relation::Name.new(:text, 'text/plain') }
    let(:schema) { ROM::Files::Schema.new(relation_name) }

    it { is_expected.to be_a Array }
    its(:size) { is_expected.to eq 2 }

    describe 'inferred' do
      subject(:inferred) { result.first }

      it { is_expected.to be_a Array }
      its(:size) { is_expected.to eq 2 }

      describe ROM::Files::ID.to_s do
        subject(:attribute) { inferred.first }

        it { is_expected.to be_a attr_class }
        its(:name) { is_expected.to eq ROM::Files::ID }
        its(:primitive) { is_expected.to eq Pathname }
        its(:primary_key?) { is_expected.to be true }
      end

      describe 'DATA' do
        subject(:attribute) { inferred[1] }

        it { is_expected.to be_a attr_class }
        its(:name) { is_expected.to eq :DATA }
        its(:primitive) { is_expected.to eq String }
        its(:primary_key?) { is_expected.to be false }
      end
    end

    describe 'missing' do
      subject(:missing) { result.last }

      it { is_expected.to be_a Array }
      its(:size) { is_expected.to eq 0 }
    end
  end
end
