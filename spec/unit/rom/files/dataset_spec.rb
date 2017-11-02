# frozen_string_literal: true

require 'rom/files/dataset'
require 'rom/lint/spec'
require 'shared/media_files'

RSpec.describe ROM::Files::Dataset do
  include_context 'media files'

  subject(:dataset) { ROM::Files::Dataset.new(path) }

  it_behaves_like "a rom enumerable dataset"
end
