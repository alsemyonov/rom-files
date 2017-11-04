# frozen_string_literal: true

require 'shared/media_relation'

RSpec.describe ROM::Files::Plugins::Schema::Contents do
  include_context 'media relation'

  subject(:schema) { schema_dsl.call }
  let(:relation) { ROM::Relation::Name[:media] }
  let(:schema_dsl) do
    ROM::Schema::DSL.new(relation, adapter: :files)
  end

  # @param name [Symbol]
  # @param type [Dry::Types::Definition]
  # @return [ROM::Attribute]
  def build_attribute(name = :__contents__, type: ROM::Types::String)
    ROM::Attribute.new(
      type.meta(name: name, source: relation, __contents__: true)
    )
  end

  describe '.apply' do
    context 'use :contents' do
      before { schema_dsl.use :contents }
      its([:__contents__]) { is_expected.to eql build_attribute }
    end
  end

  it 'supports custom types' do
    date = ROM::Types::Date
    schema_dsl.use :contents, type: date

    expect(schema[:__contents__]).to eql(build_attribute(type: date))
  end

  it 'supports custom name with options' do
    schema_dsl.use :contents, name: :contents

    expect(schema.to_h.keys).to eql(%i[contents])
  end

  it 'supports custom name' do
    schema_dsl.use :contents
    schema_dsl.contents_attribute :contents

    expect(schema.to_h.keys).to eql(%i[contents])
  end

  it 'supports custom name' do
    schema_dsl.use :contents
    schema_dsl.contents_attribute :contents

    expect(schema.to_h.keys).to eql(%i[contents])
  end
end
