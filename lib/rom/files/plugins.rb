# frozen_string_literal: true

require 'rom/plugins/relation/files/instrumentation'

require 'rom/files/plugins/schema/contents'
require 'rom/files/plugins/schema/mime'
require 'rom/files/plugins/schema/stat'

ROM.plugins do
  adapter :files do
    register :contents, ROM::Files::Plugins::Schema::Contents, type: :schema
    register :mime, ROM::Files::Plugins::Schema::Mime, type: :schema
    register :stat, ROM::Files::Plugins::Schema::Stat, type: :schema
  end
end
