# frozen_string_literal: true

require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Plugins::Schema::Mime do
  include_context 'media relation'

  subject(:schema) { schema_dsl.() }
  let(:relation) { ROM::Relation::Name[:media] }
  let(:schema_dsl) do
    ROM::Schema::DSL.new(relation, adapter: :files)
  end

  # @param name [Symbol]
  # @param type [Dry::Types::Definition]
  # @return [ROM::Attribute]
  def build_attribute(name = :mime_type, type: ROM::Files::Types::MimeType.optional)
    ROM::Attribute.new(
      type.meta(name: name, source: relation, __proc__: described_class::PROC)
    )
  end

  describe '.apply' do
    let(:type) { ROM::Types::Date }

    context 'use :mime' do
      before { schema_dsl.use :mime }
      its([:mime_type]) { is_expected.to eql build_attribute }

      context 'mime(name)' do
        before { schema_dsl.mime :custom }
        its([:custom]) { is_expected.to eql build_attribute(:custom) }
      end

      context 'mime(name, type)' do
        before { schema_dsl.mime :custom, type }
        its([:custom]) { is_expected.to eql build_attribute(:custom, type: type) }
      end

      context 'mime(name, type:)' do
        before { schema_dsl.mime :custom, type: type }
        its([:custom]) { is_expected.to eql build_attribute(:custom, type: type) }
      end

      context 'mime(type:)' do
        before { schema_dsl.mime type: type }
        its([:mime_type]) { is_expected.to eql build_attribute(type: type) }
      end
    end

    context 'use :mime, name:' do
      before { schema_dsl.use :mime, name: :mime }
      its([:mime]) { is_expected.to eql build_attribute :mime }
    end

    context 'use :mime, type:' do
      before { schema_dsl.use :mime, type: type }
      its([:mime_type]) { is_expected.to eql build_attribute type: type }
    end

    context 'use :mime, name:, type:' do
      before { schema_dsl.use :mime, name: :mime, type: type }
      its([:mime]) { is_expected.to eql build_attribute :mime, type: type }
    end
  end
end
