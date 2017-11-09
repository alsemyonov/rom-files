# frozen_string_literal: true

require 'rom/files/dataset'
require 'rom/lint/spec'
require 'shared/media_files'

RSpec.describe ROM::Files::Dataset do
  include_context 'media files'

  subject(:dataset) { ROM::Files::Dataset.new(path) }

  it_behaves_like "a rom enumerable dataset"

  its(:path) { is_expected.to eq path }
  its(:mime_type) { is_expected.to eq nil }
  its(:includes) { is_expected.to eq %w[*] }
  its(:excludes) { is_expected.to eq [] }
  its(:sort_by) { is_expected.to eq nil }
  its(:row_proc) { is_expected.to be_a Proc }
  its(:count) { is_expected.to eq 3 }
end
