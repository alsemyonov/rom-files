# frozen_string_literal: true

require 'rom/files/relation'
require 'shared/media_relation'

RSpec.describe ROM::Files::Relation do
  include_context 'media relation'

  its(:count) { is_expected.to eq 3 }
end
