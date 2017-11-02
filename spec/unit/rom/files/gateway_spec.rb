# frozen_string_literal: true

require 'rom/lint/spec'
require 'rom/files/gateway'
require 'shared/filesystem_setup'

RSpec.describe ROM::Files::Gateway do
  include_context 'filesystem setup'

  let(:gateway) { ROM::Files::Gateway }
  let(:identifier) { :files }

  it_behaves_like "a rom gateway"
end
