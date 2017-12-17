# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#recursive?' do
  include_context 'media dataset'

  subject { dataset.recursive? }

  it { is_expected.to be false }

  context 'after #recursively' do
    let(:dataset) { super().recursively }

    it { is_expected.to be true }
  end

  context 'after manual recursion via #select' do
    let(:dataset) { super().select('**/*.md') }

    it { is_expected.to be true }
  end

  context 'after manual recursion via #select without folder' do
    let(:dataset) { super().select('**') }

    it { is_expected.to be true }
  end

  context 'after manual recursion via #select without folder' do
    let(:dataset) { super().inside('**') }

    it { is_expected.to be true }
  end
end
