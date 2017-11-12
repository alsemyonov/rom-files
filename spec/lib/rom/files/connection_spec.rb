# frozen_string_literal: true

require 'rom/lint/spec'
require 'rom/files/connection'
require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Connection do
  include_context 'media relation'

  subject(:connection) { described_class.new(uri) }

  describe '#create_dataset' do
    subject(:dataset) { connection.create_dataset(name_or_mime_type) }

    context '(path)' do
      let(:name_or_mime_type) { :media }

      it { is_expected.to be_a ROM::Files::Dataset }
      its(:path) { is_expected.to eq uri.join(name_or_mime_type.to_s) }
      its(:mime_type) { is_expected.to eq nil }
    end

    context '(mime_type)' do
      let(:name_or_mime_type) { 'application/x-ruby' }

      it { is_expected.to be_a ROM::Files::Dataset }
      its(:path) { is_expected.to eq uri }
      its(:mime_type) { is_expected.to eq name_or_mime_type }
    end
  end

  describe '#key?' do
    subject { connection.key?(name) }

    context 'with existing path' do
      let(:name) { :media }

      it { is_expected.to eq true }
    end

    context 'with non-existing path' do
      let(:name) { :not_real }

      it { is_expected.to eq false }
    end

    context 'with registered MIME type' do
      let(:name) { 'application/x-ruby' }

      it { is_expected.to eq true }
    end

    context 'with unknown MIME type' do
      let(:name) { 'application/x-files' }

      it { is_expected.to eq false }
    end
  end

  describe '#search' do
    subject(:files) { connection.search(patterns, excludes: excludes, sorting: sorting, directories: directories) }
    let(:patterns) { ['*'] }
    let(:excludes) { [] }
    let(:sorting) { nil }
    let(:directories) { false }

    it { is_expected.to be_a Array }

    xcontext 'including everything'
    xcontext 'excluding images'
    xcontext 'sorting results'
    xcontext 'including directories'
  end
end
