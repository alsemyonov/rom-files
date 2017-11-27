# frozen_string_literal: true

require 'pathname/extensions'

RSpec.describe Pathname do
  before { described_class.load_extensions :partial }

  describe '#partial' do
    specify { expect(Pathname('1/2/file').partial(1)).to eq Pathname('1') }
    specify { expect(Pathname('1/2/file').partial(2)).to eq Pathname('1/2') }
    specify { expect(Pathname('1/2/file').partial(3)).to eq Pathname('1/2') }
    specify { expect(Pathname('1/2/file').partial(0)).to eq Pathname('.') }
    specify { expect(Pathname('1/2/file').partial(-1)).to eq Pathname('2') }
    specify { expect(Pathname('1/2/file').partial(-2)).to eq Pathname('1/2') }
    specify { expect(Pathname('1/2/file').partial(-3)).to eq Pathname('1/2') }
  end
end
