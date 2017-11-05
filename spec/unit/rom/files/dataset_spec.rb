# frozen_string_literal: true

require 'rom/files/dataset'
require 'rom/lint/spec'
require 'shared/media_files'

RSpec.describe ROM::Files::Dataset do
  include_context 'media files'

  subject(:dataset) { ROM::Files::Dataset.new(path) }

  it_behaves_like "a rom enumerable dataset"

  its(:includes) { is_expected.to eq %w[*] }
  its(:excludes) { is_expected.to eq [] }
  its(:sort_by) { is_expected.to eq nil }

  describe '#select' do
    let(:patterns) { [pattern] }
    let(:pattern) { '*.txt' }

    context 'dataset.select(pattern)' do
      subject { dataset.select pattern }

      its(:includes) { is_expected.to eq patterns }
    end

    context 'dataset.select(*patterns)' do
      subject { dataset.select(*patterns) }
      let(:patterns) { %w[*.txt *.md] }

      its(:includes) { is_expected.to eq patterns }
    end
  end

  describe '#reject' do
    subject { dataset.reject(*patterns) }

    context 'dataset.reject(pattern)' do
      let(:patterns) { ['*.txt'] }

      its(:excludes) { is_expected.to eq patterns }
    end

    context 'dataset.reject(*patterns)' do
      let(:patterns) { %w[*.txt *.md] }

      its(:excludes) { is_expected.to eq patterns }
    end

    context 'dataset.reject(glob_pattern)' do
      let(:patterns) { %w[*.{txt,md}] }

      its(:excludes) { is_expected.to eq patterns }
    end
  end

  describe '#sort' do
    subject { dataset.sort(*args) }

    context 'dataset.sort()' do
      let(:args) { [] }

      its(:sort_by) { is_expected.to eq :to_s }
    end

    context 'dataset.sort(:basename)' do
      let(:args) { [:basename] }

      its(:sort_by) { is_expected.to eq :basename }
    end

    context 'dataset.sort(:extname)' do
      let(:args) { [:extname] }

      its(:sort_by) { is_expected.to eq :extname }
    end
  end

  describe '#recursive' do
    subject { dataset.recursive }

    its(:includes) { is_expected.to eq ['**/*'] }

    context 'dataset.select' do
      let(:dataset) { super().select('*.txt') }

      its(:includes) { is_expected.to eq ['**/*.txt'] }
    end
  end

  describe '#recursive?' do
    subject { dataset.recursive? }

    it { is_expected.to be false }

    context 'after #recursive' do
      let(:dataset) { super().recursive }

      it { is_expected.to be true }
    end

    context 'after manual recursion via #inside' do
      let(:dataset) { super().inside('**') }

      it { is_expected.to be true }
    end

    context 'after manual recursion via #select' do
      let(:dataset) { super().select('**/*.md') }

      it { is_expected.to be true }
    end

    context 'after manual recursion via #select without folder' do
      let(:dataset) { super().select('**') }

      it { is_expected.to be false }
    end
  end
end
