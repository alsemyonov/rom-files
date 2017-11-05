# frozen_string_literal: true

require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#sort' do
  include_context 'media relation'

  subject(:names) { relation.to_a.map { |file| file[:name] } }
  let(:relation) { container.relations[:media] }

  context 'default (by path)' do
    let(:relation) { super().sort }

    it { is_expected.to eql(%w[some_file.txt some_image.png some_markdown.md]) }
  end

  context 'by extname' do
    let(:relation) { super().sort(:extname) }

    it { is_expected.to eql(%w[some_markdown.md some_image.png some_file.txt]) }
  end
end
