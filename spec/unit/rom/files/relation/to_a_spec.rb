# frozen_string_literal: true

require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#to_a' do
  include_context 'media relation'

  subject(:names) { relation.to_a.map { |file| file[:name] } }
  let(:paths) { relation.to_a.map { |file| file[:path] } }
  let(:relation) { container.relations[:media] }

  it { is_expected.to eql(%w[some_image.png some_file.txt some_markdown.md]) }

  it 'lists file paths' do
    paths = relation.to_a.map { |file| file[:path] }

    expect(paths).to eql([
                           uri.join('media/some_image.png'),
                           uri.join('media/some_file.txt'),
                           uri.join('media/some_markdown.md')
                         ])
  end

  context 'with custom view using select' do
    let(:relation) { super().text_files }

    it { is_expected.to eql %w[some_file.txt some_markdown.md] }
  end

  context 'with custom view using reject' do
    let(:relation) { super().binary_files }

    it { is_expected.to eql %w[some_image.png] }
  end
end
