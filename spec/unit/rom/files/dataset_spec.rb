# frozen_string_literal: true

require 'spec_helper'
require 'rom/lint/spec'

require 'rom/files/dataset'

RSpec.describe ROM::Files::Dataset do
  subject(:dataset) { ROM::Files::Dataset.new(path) }
  include_context 'media files'

  it_behaves_like "a rom enumerable dataset"
end
