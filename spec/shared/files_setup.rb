# frozen_string_literal: true

require 'shared/gateway_setup'

RSpec.shared_context 'files setup' do
  include_context 'gateway setup'

  let(:path) { uri.join(dir) }
  let(:data) do
    tree.map do |file, contents|
      {
        __FILE__: path.join(file),
        __contents__: contents
      }
    end
  end

  before :each do
    path.mkpath
    tree.each { |file, contents| path.join(file).write(contents) }
  end
end
