# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#inside' do
  include_context 'media dataset'

  subject(:dataset) { described_class.new(uri.join(dir)) }

  context '(dirname)' do
    subject { dataset.inside('lib') }

    its(:inside_paths) { is_expected.to eql [Pathname('lib')] }
  end

  context '(list, of, directories)' do
    subject { dataset.inside('lib', 'spec') }

    its(:inside_paths) { is_expected.to eql [Pathname('lib'), Pathname('spec')] }
  end
end
