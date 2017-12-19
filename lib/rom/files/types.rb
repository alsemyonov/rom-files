# frozen_string_literal: true

require 'dry/types/pathname'
require 'rom/types'
require 'mime/types'

module ROM
  module Files
    module Types
      include ROM::Types

      Path = Types::Pathname.meta(primary_key: true)
      RelativePath = Types::Pathname.meta(primary_key: true, relative: true)

      FileStat = Dry::Types::Definition[File::Stat].new(File::Stat)
      FileType = Coercible::String.enum('file', 'directory', 'characterSpecial',
                                        'blockSpecial', 'fifo', 'link', 'socket', 'unknown')
      MimeType = Dry::Types::Definition[MIME::Type].new(MIME::Type).optional.constructor do |type|
        MIME::Types[type].first
      end

      # Define a foreign key attribute type
      #
      # @example with default type
      #   attribute :spec_file, Types.ForeignKey(:spec_files)
      #
      # @example with a custom path map
      #   attribute :spec_file, Types.ForeignKey(:spec_files, key: ->(path) { path.pathmap('spec/%X_spec.rb') })
      #
      # @return [Dry::Types::Definition]
      #
      # @api public
      def self.ForeignKey(relation, type = Types::Pathname, map: ->(pathname) { pathname })
        super(relation, type.meta(__proc__: map))
      end
    end
  end
end
