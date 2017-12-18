# frozen_string_literal: true

require 'shared/rom/files/media_relation'
require 'rom/files/plugins/schema/properties'

RSpec.describe ROM::Files::Plugins::Schema::Properties do
  include_context 'media relation'

  subject(:schema) { schema_dsl.() }
  let(:relation_name) { ROM::Relation::Name[:media] }
  let(:schema_dsl) do
    ROM::Schema::DSL.new(relation_name, adapter: :files)
  end

  # @param property [Symbol]
  # @param type [Dry::Types::Definition]
  # @param as [Symbol]
  # @return [ROM::Attribute]
  def build_attribute(property, type: described_class::TYPE, as: property)
    ROM::Attribute.new(type.meta(name: as, source: relation_name, __proc__: property))
  end

  describe '.apply' do
    context 'use :properties' do
      before { schema_dsl.use :properties }

      context 'property :basename' do
        before { schema_dsl.property :basename }

        its([:basename]) { is_expected.to eql build_attribute(:basename) }
      end
    end

    context 'use :properties, properties:' do
      before { schema_dsl.use :properties, properties: [ROM::Files::Types::Pathname.meta(name: :extname, __proc__: :extname)] }

      its([:extname]) { is_expected.to eql build_attribute(:extname) }
    end

    context 'use :properties, names:' do
      before { schema_dsl.use :properties, names: %i[atime] }

      its('to_h.keys') { is_expected.to eql %i[atime] }
      its([:atime]) { is_expected.to eql build_attribute(:atime, type: ROM::Files::Types::Time) }
    end
  end
end
