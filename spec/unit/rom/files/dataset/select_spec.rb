# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/media_dataset'

RSpec.describe ROM::Files::Dataset, '#select' do
  include_context 'media dataset'

  context '(simple_pattern)' do
    subject { dataset.select('*.txt') }

    its(:includes) { is_expected.to eq %w[*.txt] }
  end

  context '(multiple, patterns)' do
    subject { dataset.select('*.txt', '*.md') }

    its(:includes) { is_expected.to eq %w[*.txt *.md] }
  end

  context '(multiple, duplicated patterns)' do
    subject { dataset.select('*.txt', '*.md', '*.txt') }

    its(:includes) { is_expected.to eq %w[*.txt *.md] }
  end

  context '(glob_pattern)' do
    subject { dataset.select('*.{txt,md}') }

    its(:includes) { is_expected.to eq %w[*.{txt,md}] }
  end

  context '(ordered_glob_pattern)' do
    subject { dataset.select('*.{md,txt}') }

    its(:includes) { is_expected.to eq %w[*.{md,txt}] }
  end
end
