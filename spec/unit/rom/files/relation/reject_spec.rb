# frozen_string_literal: true

require 'rom/files/relation'
require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#reject' do
  include_context 'media relation'

  subject(:names) { relation.to_a.map { |file| file[:name] } }
  let(:relation) { container.relations[:media] }

  context '(list, of, patterns)' do
    let(:relation) { super().reject('*.txt', '*.md') }

    it { is_expected.to eql %w[some_image.png] }
  end

  context '(glob_expression)' do
    let(:relation) { super().reject('*.{txt,md}') }

    it { is_expected.to eql %w[some_image.png] }
  end
end
