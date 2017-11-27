# frozen_string_literal: true

require 'pathname/extensions'

RSpec.describe Pathname do
  before { described_class.load_extensions :ext }

  describe '#ext' do
    specify { expect(Pathname('one.two').ext('net')).to eq Pathname('one.net') }
    specify { expect(Pathname('one.two').ext('.net')).to eq Pathname('one.net') }
    specify { expect(Pathname('one').ext('net')).to eq Pathname('one.net') }
    specify { expect(Pathname('one').ext('.net')).to eq Pathname('one.net') }
    specify { expect(Pathname('one.two.c').ext('.net')).to eq Pathname('one.two.net') }
    specify { expect(Pathname('one/two.c').ext('.net')).to eq Pathname('one/two.net') }
    specify { expect(Pathname('one.x/two.c').ext('.net')).to eq Pathname('one.x/two.net') }
    specify { expect(Pathname('one.x/two').ext('.net')).to eq Pathname('one.x/two.net') }
    specify { expect(Pathname('.onerc.dot').ext('net')).to eq Pathname('.onerc.net') }
    specify { expect(Pathname('.onerc').ext('net')).to eq Pathname('.onerc.net') }
    specify { expect(Pathname('.a/.onerc').ext('net')).to eq Pathname('.a/.onerc.net') }
    specify { expect(Pathname('one.two').ext('')).to eq Pathname('one') }
    specify { expect(Pathname('one.two').ext).to eq Pathname('one') }
    specify { expect(Pathname('.one.two').ext).to eq Pathname('.one') }
    specify { expect(Pathname('.one').ext).to eq Pathname('.one') }
    specify { expect(Pathname('.').ext('c')).to eq Pathname('.') }
    specify { expect(Pathname('..').ext('c')).to eq Pathname('..') }

    # These only need to work in windows
    if RbConfig::CONFIG['host_os'].match?(/(msdos|mswin|djgpp|mingw|[Ww]indows)/)
      specify { expect(Pathname('one.x\\two.c').ext('.net')).to eq Pathname('one.x\\two.net') }
      specify { expect(Pathname('one.x\\two').ext('.net')).to eq Pathname('one.x\\two.net') }
    end
  end
end
