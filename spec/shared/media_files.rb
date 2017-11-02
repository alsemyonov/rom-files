# frozen_string_literal: true

RSpec.shared_context 'media files' do
  include_context 'gateway setup'

  before :each do
    media_dir = TMP_TEST_DIR.join('media')
    media_dir.mkpath
    media_dir.join('some_file.txt').write('some content')
    media_dir.join('some_markdown.md').write('some markdown file')
    media_dir.join('some_image.png').write('')
  end
end
