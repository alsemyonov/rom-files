# frozen_string_literal: true

require 'dry/types/pathname'
require 'rom/types'

module ROM
  module Files
    module Types
      include ROM::Types

      FileStat = Dry::Types::Definition[File::Stat].new(File::Stat)
      FileType = Coercible::Pathname.enum(:file, :directory, :characterSpecial,
                                          :blockSpecial, :fifo, :link, :socket, :unknown)
    end
  end
end
