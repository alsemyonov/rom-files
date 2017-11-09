# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/media_dataset'

RSpec.describe ROM::Files::Dataset, '#mime' do
  include_context 'media dataset'

  its(:sort_by) { is_expected.to eq nil }

  context '()' do
    subject { dataset.mime }

    its(:mime_type) { is_expected.to eq nil }
  end

  context '(method)' do
    subject { dataset.sort(:basename) }

    its(:sort_by) { is_expected.to eq :basename }
  end
end
