# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#sort' do
  include_context 'media dataset'

  its(:sorting) { is_expected.to eq nil }

  context '()' do
    subject { dataset.sort }

    its(:sorting) { is_expected.to eq :to_s }
  end

  context '(method)' do
    subject { dataset.sort(:basename) }

    its(:sorting) { is_expected.to eq :basename }
  end
end
