# frozen_string_literal: true

require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Plugins::Schema::Content do
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

    context 'use :content' do
      before { schema_dsl.use :content }
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

    context 'use :content, name:' do
      before { schema_dsl.use :content, name: :contents }
      its([:contents]) { is_expected.to eql build_attribute :contents }
    end

    context 'use :content, type:' do
      before { schema_dsl.use :content, type: type }
      its([:DATA]) { is_expected.to eql build_attribute type: type }
    end

    context 'use :content, name:, type:' do
      before { schema_dsl.use :content, name: :contents, type: type }
      its([:contents]) { is_expected.to eql build_attribute :contents, type: type }
    end
  end
end
