# frozen_string_literal: true

RSpec.shared_context 'gateway setup' do
  let(:configuration) { ROM::Configuration.new(:files, TMP_TEST_DIR) }
  let(:container) { ROM.container(configuration) }
end
