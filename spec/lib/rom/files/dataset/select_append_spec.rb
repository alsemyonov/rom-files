# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/media_dataset'

RSpec.describe ROM::Files::Dataset, '#select_append' do
  include_context 'media dataset'

  context 'with blank #includes' do
    let(:dataset) { super().select }

    context '(simple_pattern)' do
      subject { dataset.select_append('*.txt') }

      its(:includes) { is_expected.to eq %w[*.txt] }
    end

    context '(multiple, patterns)' do
      subject { dataset.select_append('*.txt', '*.md') }

      its(:includes) { is_expected.to eq %w[*.txt *.md] }
    end

    context '(glob_pattern)' do
      subject { dataset.select_append('*.{txt,md}') }

      its(:includes) { is_expected.to eq %w[*.{txt,md}] }
    end

    context '(ordered_glob_pattern)' do
      subject { dataset.select_append('*.{md,txt}') }

      its(:includes) { is_expected.to eq %w[*.{md,txt}] }
    end
  end
  context 'after #select' do
    let(:dataset) { super().select('*.txt') }

    context '(duplicate_pattern)' do
      subject { dataset.select_append('*.txt') }

      its(:includes) { is_expected.to eq %w[*.txt] }
    end

    context '(simple_pattern)' do
      subject { dataset.select_append('*.md') }

      its(:includes) { is_expected.to eq %w[*.txt *.md] }
    end

    context '(multiple, duplicated, patterns)' do
      subject { dataset.select_append('*.txt', '*.md') }

      its(:includes) { is_expected.to eq %w[*.txt *.md] }
    end

    context '(glob_pattern)' do
      subject { dataset.select_append('*.{txt,md}') }

      its(:includes) { is_expected.to eq %w[*.txt *.{txt,md}] }
    end

    context '(ordered_glob_pattern)' do
      subject { dataset.select_append('*.{md,txt}') }

      its(:includes) { is_expected.to eq %w[*.txt *.{md,txt}] }
    end
  end
end
