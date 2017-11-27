# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#recursive' do
  include_context 'media dataset'

  context '()' do
    subject { dataset.recursive }

    its(:include_patterns) { is_expected.to eql ['**/*'] }
  end

  context 'with custom select' do
    subject { dataset.select('*.txt').recursive }

    its(:include_patterns) { is_expected.to eql ['**/*.txt'] }
  end

  context 'with multiple select' do
    subject { dataset.select('*.txt', '*.md').recursive }

    its(:include_patterns) { is_expected.to eql %w[**/*.txt **/*.md] }
  end
end
