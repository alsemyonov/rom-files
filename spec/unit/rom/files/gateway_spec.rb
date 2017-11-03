# frozen_string_literal: true

require 'rom/lint/spec'
require 'rom/files/gateway'
require 'shared/filesystem_setup'

RSpec.describe ROM::Files::Gateway do
  include_context 'filesystem setup'

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
end
