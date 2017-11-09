# frozen_string_literal: true

require 'dry/types/pathname'
require 'rom/types'
require 'mime/types'

module ROM
  module Files
    module Types
      include ROM::Types

      Path = Types::Pathname.meta(primary_key: true)

      FileStat = Dry::Types::Definition[File::Stat].new(File::Stat)
      FileType = Coercible::Pathname.enum(:file, :directory, :characterSpecial,
                                          :blockSpecial, :fifo, :link, :socket, :unknown)
      MimeType = Dry::Types::Definition[MIME::Type].new(MIME::Type).constructor do |type|
        MIME::Types[type].first
      end
    end
  end
end
