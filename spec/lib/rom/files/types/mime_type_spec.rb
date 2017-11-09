# frozen_string_literal: true

require 'rom/files/types'

RSpec.describe ROM::Files::Types::MimeType do
  subject(:type) { described_class }

  its(['text/plain']) { is_expected.to be_a MIME::Type }
end
