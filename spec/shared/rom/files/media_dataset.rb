# frozen_string_literal: true

require 'shared/rom/files/media_files'

RSpec.shared_context 'media dataset' do
  include_context 'media files'

  subject(:dataset) { ROM::Files::Dataset.new(connection: connection) }
  let(:connection) { ROM::Files::Connection.new(path) }
end
