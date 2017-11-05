# frozen_string_literal: true

require 'shared/media_files'

RSpec.shared_context 'media dataset' do
  include_context 'media files'

  subject(:dataset) { ROM::Files::Dataset.new(path) }
end
