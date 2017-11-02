# frozen_string_literal: true

require 'rom/lint/spec'
require 'rom/files/gateway'

RSpec.describe ROM::Files::Gateway do
  let(:gateway) { ROM::Files::Gateway }
  let(:uri) { TMP_TEST_DIR }
  let(:identifier) { :files }

  it_behaves_like "a rom gateway"
end
