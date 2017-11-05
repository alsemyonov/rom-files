# frozen_string_literal: true

require 'shared/files_setup'

RSpec.shared_context 'media files' do
  include_context 'files setup' do
    let(:dir) { 'media' }
    let(:path) { uri.join(dir) }
    let(:tree) do
      {
        'some_image.png' => '',
        'some_file.txt' => 'some content',
        'some_markdown.md' => 'some **markdown** file'
      }
    end
  end
end
