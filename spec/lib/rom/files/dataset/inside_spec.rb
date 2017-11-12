# frozen_string_literal: true

require 'rom/files/dataset'
require 'shared/rom/files/media_dataset'

RSpec.describe ROM::Files::Dataset, '#inside' do
  include_context 'media dataset'

  subject(:dataset) { described_class.new(uri.join(dir)) }

  context '(dirname)' do
    subject { dataset.inside('lib') }

    its(:includes) { is_expected.to eql ['lib/*'] }
  end

  context '(list, of, directories)' do
    subject { dataset.inside('lib', 'spec') }

    its(:includes) { is_expected.to eql %w[lib/* spec/*] }
  end
end
