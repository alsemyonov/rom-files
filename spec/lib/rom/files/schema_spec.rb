# frozen_string_literal: true

require 'rom/files/schema'
require 'shared/media_relation'

RSpec.describe ROM::Files::Schema do
  subject(:schema) { schema_proc.() }
  let(:identify) { schema.method(:identify) }

  before { schema.finalize_attributes!.finalize! }

  context 'with simple primary key' do
    let(:schema_proc) do
      Class.new(ROM::Relation[:files]).schema do
        attribute :__FILE__, ROM::Files::Types::Path
      end
    end

    its(:primary_key) { is_expected.to eql [schema[:__FILE__]] }

    describe '#identify' do
      subject { identify }

      its([__FILE__: Pathname('a')]) { is_expected.to eq Pathname('a') }
      its([__FILE__: Pathname('a'), other: 'b']) { is_expected.to eq Pathname('a') }
      its([other: 'b']) { is_expected.to eq nil }
    end
  end

  context 'with complex primary key' do
    let(:schema_proc) do
      Class.new(ROM::Relation[:files]).schema do
        attribute :dir, ROM::Files::Types::Path
        attribute :path, ROM::Files::Types::Path
      end
    end

    its(:primary_key) { is_expected.to eql [schema[:dir], schema[:path]] }

    describe '#identify' do
      subject { identify }

      its([dir: Pathname('lib/'), path: Pathname('file.rb')]) { is_expected.to eq Pathname('lib/file.rb') }
      its([dir: Pathname('lib/')]) { is_expected.to eq Pathname('lib/') }
      its([path: Pathname('file.rb')]) { is_expected.to eq Pathname('file.rb') }
      its([other: 'b']) { is_expected.to eq nil }
    end
  end

  context 'without primary key defined' do
    let(:schema_proc) do
      Class.new(ROM::Relation[:files]).schema do
        attribute :__FILE__, ROM::Files::Types::Pathname
      end
    end

    its(:primary_key) { is_expected.to eql [] }

    describe '#identify' do
      subject { identify }

      its([__FILE__: Pathname('a')]) { is_expected.to eq Pathname('a') }
      its([__FILE__: Pathname('a'), other: 'b']) { is_expected.to eq Pathname('a') }
      its([other: 'b']) { is_expected.to eq nil }
    end
  end
end
