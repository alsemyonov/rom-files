# frozen_string_literal: true

require 'rom/files/schema/dsl'
require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Schema::DSL do
  include_context 'media relation'

  subject(:schema_dsl) { described_class.new(relation, adapter: :files) }
  let(:schema) { schema_dsl.() }
  let(:relation) { ROM::Relation::Name[:media] }

  # @param name [Symbol]
  # @param type [Dry::Types::Definition]
  # @return [ROM::Attribute]
  def build_attribute(name = :DATA, type: ROM::Types::String)
    ROM::Attribute.new(type.meta(name: name, source: relation, ROM::Files::DATA => true))
  end

  describe '#contents' do
    subject { schema }

    let(:type) { ROM::Types::Date }

    context '()' do
      before { schema_dsl.contents }

      its('attributes.size') { is_expected.to eq 1 }
      its([ROM::Files::DATA]) { is_expected.to eql build_attribute }
    end

    context '(name)' do
      before { schema_dsl.contents :custom }
      its([:custom]) { is_expected.to eql build_attribute(:custom) }
    end

    context '(name, type)' do
      before { schema_dsl.contents :custom, type }
      its([:custom]) { is_expected.to eql build_attribute(:custom, type: type) }
    end

    context '(name, type:)' do
      before { schema_dsl.contents :custom, type: type }
      its([:custom]) { is_expected.to eql build_attribute(:custom, type: type) }
    end

    context '(type:)' do
      before { schema_dsl.contents type: type }
      its([:DATA]) { is_expected.to eql build_attribute(type: type) }
    end

    context '(name, type) do ... end' do
      before do
        schema_dsl.contents :custom, ROM::Files::Types::Yaml do
          attribute :nested, ROM::Files::Types::Date
        end
      end
    end
  end
end
