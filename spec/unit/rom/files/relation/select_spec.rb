# frozen_string_literal: true

require 'rom/files/relation'
require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#select' do
  include_context 'media relation'

  subject(:names) { relation.to_a.map { |file| file[:name] } }
  let(:relation) { container.relations[:media] }

  context '(simple_pattern)' do
    let(:relation) { super().select('*.txt') }

    it { is_expected.to eql %w[some_file.txt] }
  end

  context '(multiple, patterns)' do
    let(:relation) { super().select('*.txt', '*.md') }

    it { is_expected.to eql %w[some_file.txt some_markdown.md] }
  end

  context '(glob_pattern)' do
    let(:relation) { super().select('*.{txt,md}') }

    it { is_expected.to eql %w[some_file.txt some_markdown.md] }
  end

  context '(ordered_glob_pattern)' do
    let(:relation) { super().select('*.{md,txt}') }

    it { is_expected.to eql %w[some_markdown.md some_file.txt] }
  end
end
