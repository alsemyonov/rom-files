# frozen_string_literal: true

require 'shared/media_relation'

RSpec.describe ROM::Files::Plugins::Schema::Contents do
  include_context 'media relation'

  subject(:schema) { schema_dsl.() }
  let(:relation) { ROM::Relation::Name[:media] }
  let(:schema_dsl) do
    ROM::Schema::DSL.new(relation, adapter: :files)
  end

  # @param name [Symbol]
  # @param type [Dry::Types::Definition]
  # @return [ROM::Attribute]
  def build_attribute(name = :DATA, type: ROM::Types::String)
    ROM::Attribute.new(
      type.meta(name: name, source: relation, DATA: true)
    )
  end

  describe '.apply' do
    let(:type) { ROM::Types::Date }

    context 'use :contents' do
      before { schema_dsl.use :contents }
      its([:DATA]) { is_expected.to eql build_attribute }

      context 'contents(name)' do
        before { schema_dsl.contents :custom }
        its([:custom]) { is_expected.to eql build_attribute(:custom) }
      end

      context 'contents(name, type)' do
        before { schema_dsl.contents :custom, type }
        its([:custom]) { is_expected.to eql build_attribute(:custom, type: type) }
      end

      context 'contents(name, type:)' do
        before { schema_dsl.contents :custom, type: type }
        its([:custom]) { is_expected.to eql build_attribute(:custom, type: type) }
      end

      context 'contents(type:)' do
        before { schema_dsl.contents type: type }
        its([:DATA]) { is_expected.to eql build_attribute(type: type) }
      end
    end

    context 'use :contents, name:' do
      before { schema_dsl.use :contents, name: :contents }
      its([:contents]) { is_expected.to eql build_attribute :contents }
    end

    context 'use :contents, type:' do
      before { schema_dsl.use :contents, type: type }
      its([:DATA]) { is_expected.to eql build_attribute type: type }
    end

    context 'use :contents, name:, type:' do
      before { schema_dsl.use :contents, name: :contents, type: type }
      its([:contents]) { is_expected.to eql build_attribute :contents, type: type }
    end
  end
end
