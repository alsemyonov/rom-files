# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/media_dataset'

RSpec.describe ROM::Files::Dataset, '#mime' do
  include_context 'media dataset'

  its(:mime_type) { is_expected.to eq nil }

  context '()' do
    subject { dataset.mime }

    its(:mime_type) { is_expected.to eq nil }
  end

  context '(method)' do
    subject { dataset.mime('application/x-ruby') }

    its(:mime_type) { is_expected.to eq 'application/x-ruby' }
    its(:includes) { is_expected.to eq %w[*.rb *.rbw] }
  end
end
