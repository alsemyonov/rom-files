# frozen_string_literal: true

require 'rom/files/schema'
require 'shared/media_relation'

RSpec.describe ROM::Files::Schema do
  subject(:schema) { schema_proc.() }
  let(:identify) { schema.method(:identify) }
  let(:contents_for) { schema.method(:contents_for) }

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

  context 'with simple contents attribute' do
    let(:schema_proc) do
      Class.new(ROM::Relation[:files]).schema do
        attribute :path, ROM::Files::Types::Path
        attribute :contents, ROM::Files::Types::String.meta(DATA: true)
      end
    end

    its(:primary_key) { is_expected.to eql [schema[:path]] }

    describe '#contents_for' do
      subject { contents_for }

      its([contents: 'Contents']) { is_expected.to eq 'Contents' }
      its([contents: '']) { is_expected.to eq '' }
      its([contents: nil]) { is_expected.to eq nil }
      its([other: 'b']) { is_expected.to eq nil }
    end
  end

  context 'with complex simple contents attribute' do
    let(:schema_proc) do
      Class.new(ROM::Relation[:files]).schema do
        attribute :path, ROM::Files::Types::Path
        attribute :header, ROM::Files::Types::String.meta(DATA: true)
        attribute :footer, ROM::Files::Types::String.meta(DATA: true)
      end
    end

    its(:primary_key) { is_expected.to eql [schema[:path]] }

    describe '#contents_for' do
      subject { contents_for }

      its([header: "Header\n", footer: "Footer\n"]) { is_expected.to eq "Header\nFooter\n" }
      its([header: "Header\n"]) { is_expected.to eq "Header\n" }
      its([footer: "Footer\n"]) { is_expected.to eq "Footer\n" }
      its([contents: '']) { is_expected.to eq nil }
    end
  end
end
