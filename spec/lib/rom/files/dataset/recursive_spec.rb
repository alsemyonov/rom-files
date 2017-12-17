# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#recursively' do
  include_context 'media dataset'

  context '()' do
    subject { dataset.recursively }

    its(:search_recursive) { is_expected.to eql true }
    its(:search_patterns) { is_expected.to eql [Pathname('**/*')] }
  end

  context 'with custom select' do
    subject { dataset.select('*.txt').recursively }

    its(:search_recursive) { is_expected.to eql true }
    its(:search_patterns) { is_expected.to eql [Pathname('**/*.txt')] }
  end

  context 'with multiple select' do
    subject { dataset.select('*.txt', '*.md').recursively }

    its(:search_recursive) { is_expected.to eql true }
    its(:search_patterns) { is_expected.to eql [Pathname('**/*.txt'), Pathname('**/*.md')] }
  end
end
