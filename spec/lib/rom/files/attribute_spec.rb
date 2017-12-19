# frozen_string_literal: true

require 'rom/files/attribute'
require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Attribute do
  Types = ROM::Files::Types

  subject(:attribute) { described_class.new(type.meta(name: name)) }
  let(:type) { Types::String }
  let(:name) { :attr_name }
  let(:path) { Pathname(__FILE__) }

  it { is_expected.to be_a described_class } # no-op

  describe '#call' do
    subject(:call) { attribute.method(:call) }

    context 'with relative:' do
      let(:type) { Types::RelativePath }

      its([Pathname(__FILE__), root: Pathname(__dir__)]) { is_expected.to eq Pathname('attribute_spec.rb') }
    end

    context 'with DATA' do
      let(:type) { Types::String.meta(DATA: true) }

      its([Pathname(__FILE__)]) { is_expected.to eq File.read(__FILE__) }
    end

    context 'with stat' do
      let(:type) { Types::FileStat.meta(__stat__: true) }

      its([Pathname(__FILE__)]) { is_expected.to eq File.stat(__FILE__) }
    end

    context 'with specific stat' do
      let(:type) { Types::Int.meta(__stat__: :mode) }

      its([Pathname(__FILE__)]) { is_expected.to eq 0o0100644 }
    end

    context 'with proc' do
      let(:type) { Types::String.meta(__proc__: ->(path) { path.extname }) }

      its([Pathname(__FILE__)]) { is_expected.to eq '.rb' }
    end
  end
end
