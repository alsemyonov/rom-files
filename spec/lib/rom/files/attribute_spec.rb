# frozen_string_literal: true

require 'rom/files/attribute'
require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Attribute do
  subject(:attribute) { described_class.new(type.meta(name: name)) }
  let(:type) { ROM::Files::Types::String }
  let(:name) { :attr_name }
  let(:path) { Pathname(__FILE__) }

  it { is_expected.to be_a described_class } # no-op

  describe '#call' do
    subject(:call) { attribute.method(:call) }

    context 'with relative:' do
      let(:type) { ROM::Files::Types::RelativePath }

      its([Pathname(__FILE__), root: Pathname(__dir__)]) { is_expected.to eq Pathname('attribute_spec.rb') }
    end

    context 'with DATA' do
      let(:type) { ROM::Files::Types::String.meta(DATA: true) }

      its([Pathname(__FILE__)]) { is_expected.to eq File.read(__FILE__) }
    end
  end

  describe '#processor?' do
    context '(__proc__: Symbol)' do
      let(:type) { ROM::Files::Types::String.meta(__proc__: :extname) }

      its(:processor?) { is_expected.to be_truthy }
      its(:processor) { is_expected.to be_a Proc }

      specify { expect(attribute.(Pathname(__FILE__))).to eq '.rb' }
    end

    context '(__proc__: Proc)' do
      let(:type) { ROM::Files::Types::String.meta(__proc__: ->(path) { path.extname }) }

      its(:processor?) { is_expected.to be_truthy }
      its(:processor) { is_expected.to be_a Proc }

      specify { expect(attribute.(Pathname(__FILE__))).to eq '.rb' }
    end
  end

  describe '#data?' do
    let(:type) { ROM::Files::Types::String.meta(DATA: true) }

    its(:data?) { is_expected.to be_truthy }

    specify { expect(attribute.(Pathname(__FILE__))).to eq File.read(__FILE__) }
  end

  describe '#stat?, #stat_property, #stat_property?' do
    context 'meta()' do
      let(:type) { ROM::Files::Types::FileStat }

      its(:stat?) { is_expected.to be_falsey }
      its(:stat_property) { is_expected.to eq nil }
      its(:stat_property?) { is_expected.to be_falsey }
    end

    context 'meta(__stat__: true)' do
      let(:type) { ROM::Files::Types::FileStat.meta(__stat__: true) }

      its(:stat?) { is_expected.to eq true }
      its(:stat_property) { is_expected.to eq nil }
      its(:stat_property?) { is_expected.to eq false }

      specify { expect(attribute.(Pathname(__FILE__))).to eq File.stat(__FILE__) }
    end

    context 'meta(__stat__: :atime)' do
      let(:type) { ROM::Files::Types::FileStat.meta(__stat__: :mode) }

      its(:stat?) { is_expected.to eq false }
      its(:stat_property) { is_expected.to eq :mode }
      its(:stat_property?) { is_expected.to be_truthy }

      specify { expect(attribute.(Pathname(__FILE__))).to eq 0o0100644 }
    end
  end
end
