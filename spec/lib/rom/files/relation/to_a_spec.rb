# frozen_string_literal: true

require 'shared/rom/files/media_relation'

RSpec.describe ROM::Files::Relation, '#to_a' do
  include_context 'media relation'

  let(:names) { relation.pluck(:basename) }
  let(:paths) { relation.to_a.map { |file| file[ROM::Files::ID] } }

  its(:to_a) { is_expected.to eq data }
  its(:schema) { is_expected.to be_a ROM::Files::Schema }

  it 'lists file paths' do
    expect(paths).to eql([
                           path.join('some_image.png'),
                           path.join('some_file.txt'),
                           path.join('some_markdown.md')
                         ])
  end

  context 'names' do
    subject { names }

    it { is_expected.to eql([P('some_image.png'), P('some_file.txt'), P('some_markdown.md')]) }

    context 'with custom view using select' do
      let(:relation) { super().text_files }

      it { is_expected.to eql [P('some_file.txt'), P('some_markdown.md')] }
    end

    context 'with custom view using reject' do
      let(:relation) { super().binary_files }

      it { is_expected.to eql [P('some_image.png')] }
    end
  end
end
