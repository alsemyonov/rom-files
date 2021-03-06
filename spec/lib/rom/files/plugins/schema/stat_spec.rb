# frozen_string_literal: true

require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Plugins::Schema::Stat do
  FIELD = ROM::Files::Plugins::Schema::Stat::NAME

  include_context 'media relation'

  subject(:schema) { schema_dsl.() }
  let(:relation_name) { ROM::Relation::Name[:media] }
  let(:schema_dsl) do
    ROM::Schema::DSL.new(relation_name, adapter: :files)
  end

  # @param name [Symbol]
  # @param type [Dry::Types::Definition]
  # @param stat [Symbol]
  # @return [ROM::Attribute]
  def build_attribute(name = FIELD,
                      type: ROM::Files::Types::FileStat,
                      stat: (name == FIELD) || name)
    ROM::Attribute.new(
      type.meta(name: name, source: relation_name, __stat__: stat)
    )
  end

  describe '.apply' do
    context 'use :stat' do
      before { schema_dsl.use :stat }

      its([:stat]) { is_expected.to eql build_attribute }

      context 'stat :stat' do
        before { schema_dsl.stat :stat }

        its([:stat]) { is_expected.to eql build_attribute(:stat) }
      end

      context 'stat stats:' do
        before { schema_dsl.stat stats: %i[atime] }

        its('to_h.keys') { is_expected.to eql %i[stat atime] }
        its([:stat]) { is_expected.to eql build_attribute }
        its([:atime]) { is_expected.to eql build_attribute(:atime, type: ROM::Files::Types::Time) }
      end

      context 'stat false, stats:' do
        before { schema_dsl.stat false, stats: %i[atime] }

        its('to_h.keys') { is_expected.to eql %i[atime] }
        its([:atime]) { is_expected.to eql build_attribute(:atime, type: ROM::Files::Types::Time) }
      end

      context 'stat stats: [aliased]' do
        before { schema_dsl.stat stats: %i[created_at] }

        its('to_h.keys') { is_expected.to eql %i[stat created_at] }
        its([:stat]) { is_expected.to eql build_attribute }
        its([:created_at]) { is_expected.to eql build_attribute(:created_at, type: ROM::Files::Types::Time, stat: :birthtime) }
      end

      context 'stat aliases:' do
        before { schema_dsl.stat aliases: { modified_at: :mtime } }

        its('to_h.keys') { is_expected.to eql %i[stat modified_at] }
        its([:stat]) { is_expected.to eql build_attribute }
        its([:modified_at]) { is_expected.to eql build_attribute(:modified_at, type: ROM::Files::Types::Time, stat: :mtime) }
      end
    end

    context 'use :stat, name:' do
      before { schema_dsl.use :stat, name: :stat }

      its([:stat]) { is_expected.to eql build_attribute(:stat) }
    end

    context 'use :stat, stats:' do
      before { schema_dsl.use :stat, stats: %i[atime] }

      its('to_h.keys') { is_expected.to eql %i[stat atime] }
      its([:stat]) { is_expected.to eql build_attribute }
      its([:atime]) { is_expected.to eql build_attribute(:atime, type: ROM::Files::Types::Time) }
    end

    context 'use :stat, name: false, stats:' do
      before { schema_dsl.use :stat, name: false, stats: %i[atime] }

      its('to_h.keys') { is_expected.to eql %i[atime] }
      its([:atime]) { is_expected.to eql build_attribute(:atime, type: ROM::Files::Types::Time) }
    end

    context 'use :stat, stats: [aliased]' do
      before { schema_dsl.use :stat, stats: %i[created_at] }

      its('to_h.keys') { is_expected.to eql %i[stat created_at] }
      its([:stat]) { is_expected.to eql build_attribute }
      its([:created_at]) { is_expected.to eql build_attribute(:created_at, type: ROM::Files::Types::Time, stat: :birthtime) }
    end

    context 'use :stat, aliases:' do
      before { schema_dsl.use :stat, aliases: { modified_at: :mtime } }

      its('to_h.keys') { is_expected.to eql %i[stat modified_at] }
      its([:stat]) { is_expected.to eql build_attribute }
      its([:modified_at]) { is_expected.to eql build_attribute(:modified_at, type: ROM::Files::Types::Time, stat: :mtime) }
    end
  end
end
