# frozen_string_literal: true

RSpec.shared_context 'filesystem setup' do
  let(:uri) { SPEC_ROOT.join('../tmp/test') }

  before do
    uri.rmtree if uri.directory?
    uri.mkpath
  end
end
