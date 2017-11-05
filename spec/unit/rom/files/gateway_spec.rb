# frozen_string_literal: true

require 'rom/lint/spec'
require 'rom/files/gateway'
require 'shared/media_relation'

RSpec.describe ROM::Files::Gateway do
  include_context 'media relation'

  subject(:gateway_instance) { ROM::Gateway.setup(identifier, uri) }
  let(:gateway) { described_class }
  let(:identifier) { :files }

  it_behaves_like "a rom gateway"

  describe '#use_logger' do
    it 'sets logger' do
      gateway_instance.use_logger(:logger)
      expect(gateway_instance.logger).to eq :logger
    end
  end

  describe '#dataset?' do
    subject { gateway_instance.dataset?(relation) }

    context 'with existing relation' do
      let(:relation) { :media }

      it { is_expected.to be true }
    end

    context 'with non-existing relation' do
      let(:relation) { :not_here }

      it { is_expected.to be false }
    end
  end
end
