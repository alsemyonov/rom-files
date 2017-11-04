# frozen_string_literal: true

require 'shared/media_relation'

RSpec.describe 'Reading relations' do
  include_context 'media relation'

  subject(:names) { relation.to_a.map { |file| file[:name] } }
  let(:paths) { relation.to_a.map { |file| file[:path] } }
  let(:media) { container.relations[:media] }
  let(:relation) { media }

  it 'lists file paths' do
    paths = media.to_a.map { |file| file[:path] }

    expect(paths).to eql([
                           uri.join('media/some_image.png'),
                           uri.join('media/some_file.txt'),
                           uri.join('media/some_markdown.md')
                         ])
  end

  describe '#to_a' do
    it { is_expected.to eql(%w[some_image.png some_file.txt some_markdown.md]) }
  end

  describe '#sort' do
    context 'default (by basename)' do
      let(:relation) { media.sort }

      it { is_expected.to eql(%w[some_file.txt some_image.png some_markdown.md]) }
    end

    context 'by extname' do
      let(:relation) { media.sort(:extname) }

      it { is_expected.to eql(%w[some_markdown.md some_image.png some_file.txt]) }
    end
  end

  describe '#select' do
    context 'generic' do
      let(:relation) { media.select('*.txt') }

      it { is_expected.to eql %w[some_file.txt] }
    end

    context 'glob' do
      let(:relation) { media.select('*.{txt,md}') }

      it { is_expected.to eql %w[some_file.txt some_markdown.md] }
    end

    context 'ordered glob' do
      let(:relation) { media.select('*.{md,txt}') }

      it { is_expected.to eql %w[some_markdown.md some_file.txt] }
    end
  end

  describe '#reject' do
    context 'list' do
      let(:relation) { media.reject('*.txt', '*.md') }

      it { is_expected.to eql %w[some_image.png] }
    end

    context 'glob' do
      let(:relation) { media.reject('*.{txt,md}') }

      it { is_expected.to eql %w[some_image.png] }
    end
  end

  describe '#inside' do
    subject(:relation) { media.select('*.rb').inside('lib') }

    its('dataset.includes') { is_expected.to eql ['lib/*.rb'] }
  end

  describe '#recursive' do
    subject(:relation) { media.select('*.txt').recursive }

    its('dataset.includes') { is_expected.to eql ['**/*.txt'] }
  end

  describe 'custom views' do
    context '#select' do
      let(:relation) { media.text_files }

      it { is_expected.to eql %w[some_file.txt some_markdown.md] }
    end

    context '#reject' do
      let(:relation) { media.binary_files }

      it { is_expected.to eql %w[some_image.png] }
    end
  end
end
