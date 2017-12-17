# frozen_string_literal: true

require 'rom/files/dataset'
require 'rom/lint/spec'
require 'shared/rom/files/media_files'

RSpec.describe ROM::Files::Dataset do
  include_context 'media files'

  subject(:dataset) { connection.create_dataset(dir) }
  let(:connection) { ROM::Files::Connection.new(uri) }

  it_behaves_like "a rom enumerable dataset"

  its(:path) { is_expected.to eq path }
  its(:mime_type) { is_expected.to eq nil }
  its(:include_patterns) { is_expected.to eq %w[*] }
  its(:exclude_patterns) { is_expected.to eq [] }
  its(:sorting) { is_expected.to eq nil }
  its(:row_proc) { is_expected.to be_a Proc }
  its(:count) { is_expected.to eq 3 }
  its(:each) { is_expected.to be_a Enumerator }

  describe '#with' do
    subject(:new_dataset) { dataset.with(options) }
    let(:options) { {} }

    context '(path:)' do
      let(:options) { Hash[path: Pathname.pwd] }
      its(:path) { is_expected.to eq Pathname.pwd }
    end
  end

  context '#at' do
    subject(:new_dataset) { dataset.at('~') }

    its(:path) { is_expected.to eq Pathname('~') }
  end

  context '#up' do
    subject(:new_dataset) { dataset.up }

    its(:path) { is_expected.to eq path.join('..') }
  end

  context '#dig' do
    subject(:new_dataset) { dataset.up.dig(dir) }

    its(:path) { is_expected.to eq path.join('../media') }
  end
end
