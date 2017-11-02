# frozen_string_literal: true

RSpec.shared_context 'filesystem setup' do
  let(:uri) { SPEC_ROOT.join('../tmp/test') }

  before do
    uri.rmtree
    uri.mkpath
  end
end
