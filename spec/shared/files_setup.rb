# frozen_string_literal: true

require 'shared/gateway_setup'

RSpec.shared_context 'files setup' do
  include_context 'gateway setup'

  let(:path) { uri.join(dir) }
  let(:data) do
    tree.map do |file, _|
      { name: file, path: path.join(file) }
    end
  end

  before :each do
    path.mkpath
    tree.each { |file, tree| path.join(file).write(tree) }
  end
end
