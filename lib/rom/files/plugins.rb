# frozen_string_literal: true

require 'rom/files/plugins/schema/contents'

ROM.plugins do
  adapter :files do
    register :contents, ROM::Files::Plugins::Schema::Contents, type: :schema
  end
end
