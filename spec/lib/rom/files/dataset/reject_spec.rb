# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#reject' do
  include_context 'media dataset'

  context 'dataset.reject(pattern)' do
    subject { dataset.reject('*.txt') }

    its(:excludes) { is_expected.to eq %w[*.txt] }
  end

  context '(list, of, patterns)' do
    subject { dataset.reject('*.txt', '*.md') }

    its(:excludes) { is_expected.to eq %w[*.txt *.md] }
  end

  context '(glob_expression)' do
    subject { dataset.reject('*.{txt,md}') }

    its(:excludes) { is_expected.to eq %w[*.{txt,md}] }
  end
end
