# frozen_string_literal: true

require 'shared/media_files'

RSpec.describe 'Reading relations' do
  include_context 'media files'

  before :each do
    configuration.relation(:media) do
      dataset { sort }

      # @return [ROM::Files::Relation]
      def text_files
        select('*.txt')
      end
    end
  end

  let(:media) { container.relations[:media] }

  it 'lists file paths' do
    paths = media.to_a.map { |file| file[:path] }

    expect(paths).to eql([
                           uri.join('media/some_file.txt'),
                           uri.join('media/some_image.png'),
                           uri.join('media/some_markdown.md')
                         ])
  end

  it 'lists file names' do
    names = media.to_a.map { |file| file[:name] }

    expect(names).to eql(%w[some_file.txt some_image.png some_markdown.md])
  end

  it 'selects files' do
    files = media.text_files.to_a.map { |file| file[:name] }

    expect(files).to eql(%w[some_file.txt])
  end
end
