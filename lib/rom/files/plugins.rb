# frozen_string_literal: true

require 'rom/files/plugins/schema/contents'
require 'rom/files/plugins/schema/stat'

ROM.plugins do
  adapter :files do
    register :contents, ROM::Files::Plugins::Schema::Contents, type: :schema
    register :stat, ROM::Files::Plugins::Schema::Stat, type: :schema
  end
end
