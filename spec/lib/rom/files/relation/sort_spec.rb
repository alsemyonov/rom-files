# frozen_string_literal: true

require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Relation, '#sort' do
  include_context 'media relation'

  subject(:names) { relation.pluck(:basename) }

  context 'default (by path)' do
    let(:relation) { super().sort }

    it { is_expected.to eql([P('some_file.txt'), P('some_image.png'), P('some_markdown.md')]) }
  end

  context 'by extname' do
    let(:relation) { super().sort(:extname) }

    it { is_expected.to eql([P('some_markdown.md'), P('some_image.png'), P('some_file.txt')]) }
  end
end
