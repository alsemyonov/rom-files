# frozen_string_literal: true

require 'pathname/extensions'

RSpec.describe Pathname do
  before { described_class.load_extensions :explode }

  describe '#explode' do
    specify { expect(Pathname('a').explode).to eq [Pathname('a')] }
    specify { expect(Pathname('a/b').explode).to eq [Pathname('a'), Pathname('b')] }
    specify { expect(Pathname('a/b/c').explode).to eq [Pathname('a'), Pathname('b'), Pathname('c')] }
    specify { expect(Pathname('/a').explode).to eq [Pathname('/'), Pathname('a')] }
    specify { expect(Pathname('/a/b').explode).to eq [Pathname('/'), Pathname('a'), Pathname('b')] }
    specify { expect(Pathname('/a/b/c').explode).to eq [Pathname('/'), Pathname('a'), Pathname('b'), Pathname('c')] }

    if File::ALT_SEPARATOR
      specify { expect(Pathname('c:a').explode).to eq [Pathname('c:.'), Pathname('a')] }
      specify { expect(Pathname('c:a/b').explode).to eq [Pathname('c:.'), Pathname('a'), Pathname('b')] }
      specify { expect(Pathname('c:a/b/c').explode).to eq [Pathname('c:.'), Pathname('a'), Pathname('b'), Pathname('c')] }
      specify { expect(Pathname('c:/a').explode).to eq [Pathname('c:/'), Pathname('a')] }
      specify { expect(Pathname('c:/a/b').explode).to eq [Pathname('c:/'), Pathname('a'), Pathname('b')] }
      specify { expect(Pathname('c:/a/b/c').explode).to eq [Pathname('c:/'), Pathname('a'), Pathname('b'), Pathname('c')] }
    end
  end
end
