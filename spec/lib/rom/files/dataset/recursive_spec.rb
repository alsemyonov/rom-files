# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#recursively' do
  include_context 'media dataset'

  context '()' do
    subject { dataset.recursively }

    its(:include_patterns) { is_expected.to eql %w[**/*] }
  end

  context 'with custom select' do
    subject { dataset.select('*.txt').recursively }

    its(:include_patterns) { is_expected.to eql %w[**/*.txt] }
  end

  context 'with multiple select' do
    subject { dataset.select('*.txt', '*.md').recursively }

    its(:include_patterns) { is_expected.to eql %w[**/*.txt **/*.md] }
  end
end
