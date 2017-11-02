# frozen_string_literal: true

require 'spec_helper'
require 'rom/lint/spec'

require 'rom/files/dataset'

RSpec.describe ROM::Files::Dataset do
  include_context 'media files'

  subject(:dataset) { ROM::Files::Dataset.new(path) }

  it_behaves_like "a rom enumerable dataset"
end
