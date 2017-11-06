# frozen_string_literal: true

require 'rom/files/relation'
require 'shared/media_relation'

RSpec.describe ROM::Files::Relation, '#pluck' do
  include_context 'media relation'

  context 'with method name' do
    subject { relation.pluck(:basename) }
    it { is_expected.to eql([Pathname('some_image.png'), Pathname('some_file.txt'), Pathname('some_markdown.md')]) }
  end

  context 'with block' do
    subject { relation.pluck { |path| path.basename.to_s } }

    it { is_expected.to eql %w[some_image.png some_file.txt some_markdown.md] }
  end
end
