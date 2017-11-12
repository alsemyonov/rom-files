# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#reject_append' do
  include_context 'media dataset'

  context 'with blank #excludes' do
    context '(simple_pattern)' do
      subject { dataset.reject_append('*.txt') }

      its(:excludes) { is_expected.to eq %w[*.txt] }
    end

    context '(multiple, patterns)' do
      subject { dataset.reject_append('*.txt', '*.md') }

      its(:excludes) { is_expected.to eq %w[*.txt *.md] }
    end

    context '(glob_pattern)' do
      subject { dataset.reject_append('*.{txt,md}') }

      its(:excludes) { is_expected.to eq %w[*.{txt,md}] }
    end

    context '(ordered_glob_pattern)' do
      subject { dataset.reject_append('*.{md,txt}') }

      its(:excludes) { is_expected.to eq %w[*.{md,txt}] }
    end
  end

  context 'after #reject' do
    let(:dataset) { super().reject('*.txt') }

    context '(duplicate_pattern)' do
      subject { dataset.reject_append('*.txt') }

      its(:excludes) { is_expected.to eq %w[*.txt] }
    end

    context '(simple_pattern)' do
      subject { dataset.reject_append('*.md') }

      its(:excludes) { is_expected.to eq %w[*.txt *.md] }
    end

    context '(multiple, duplicated, patterns)' do
      subject { dataset.reject_append('*.txt', '*.md') }

      its(:excludes) { is_expected.to eq %w[*.txt *.md] }
    end

    context '(glob_pattern)' do
      subject { dataset.reject_append('*.{txt,md}') }

      its(:excludes) { is_expected.to eq %w[*.txt *.{txt,md}] }
    end

    context '(ordered_glob_pattern)' do
      subject { dataset.reject_append('*.{md,txt}') }

      its(:excludes) { is_expected.to eq %w[*.txt *.{md,txt}] }
    end
  end
end
