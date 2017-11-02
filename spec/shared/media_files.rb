# frozen_string_literal: true

RSpec.shared_context 'media files' do
  include_context 'gateway setup'

  let(:dir) { 'media' }
  let(:path) { TMP_TEST_DIR.join(dir) }
  let(:tree) do
    {
      'some_image.png' => '',
      'some_file.txt' => 'some content',
      'some_markdown.md' => 'some **markdown** file'
    }
  end
  let(:data) do
    tree.map do |file, _|
      { name: file, path: path.join(file) }
    end
  end

  before :each do
    path.mkpath
    tree.each { |file, tree| path.join(file).write(tree) }
  end
end
