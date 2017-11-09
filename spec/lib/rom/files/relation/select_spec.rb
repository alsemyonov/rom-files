# frozen_string_literal: true

require 'rom/files/relation'
require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#select' do
  include_context 'media relation'

  subject(:names) { relation.pluck(:basename) }
  let(:relation) { container.relations[:media] }

  context '(simple_pattern)' do
    let(:relation) { super().select('*.txt') }

    it { is_expected.to eql [P('some_file.txt')] }
  end

  context '(multiple, patterns)' do
    let(:relation) { super().select('*.txt', '*.md') }

    it { is_expected.to eql [P('some_file.txt'), P('some_markdown.md')] }
  end

  context '(glob_pattern)' do
    let(:relation) { super().select('*.{txt,md}') }

    it { is_expected.to eql [P('some_file.txt'), P('some_markdown.md')] }
  end

  context '(ordered_glob_pattern)' do
    let(:relation) { super().select('*.{md,txt}') }

    it { is_expected.to eql [P('some_markdown.md'), P('some_file.txt')] }
  end
end
