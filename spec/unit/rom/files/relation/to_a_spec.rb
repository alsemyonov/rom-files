# frozen_string_literal: true

require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#to_a' do
  include_context 'media relation'

  let(:names) { relation.to_a.map { |file| file[:__basename__] } }
  let(:paths) { relation.to_a.map { |file| file[:__path__] } }

  its(:to_a) { is_expected.to eq data }

  it 'lists file paths' do
    expect(paths).to eql([
                           uri.join('media/some_image.png'),
                           uri.join('media/some_file.txt'),
                           uri.join('media/some_markdown.md')
                         ])
  end

  context 'names' do
    subject { names }

    it { is_expected.to eql(%w[some_image.png some_file.txt some_markdown.md]) }

    context 'with custom view using select' do
      let(:relation) { super().text_files }

      it { is_expected.to eql %w[some_file.txt some_markdown.md] }
    end

    context 'with custom view using reject' do
      let(:relation) { super().binary_files }

      it { is_expected.to eql %w[some_image.png] }
    end
  end
end
