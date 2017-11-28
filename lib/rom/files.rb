# frozen_string_literal: true

require 'dry/types/pathname'
require 'rom'

require 'rom/files/version'
require 'rom/files/gateway'
require 'rom/files/relation'

ROM.register_adapter :files, ROM::Files

require 'rom/files/plugins/relation/instrumentation'
require 'rom/files/plugins/schema/contents'
require 'rom/files/plugins/schema/mime'
require 'rom/files/plugins/schema/shebang'
require 'rom/files/plugins/schema/stat'
require 'rom/files/plugins/configuration/gem'

ROM.plugins do
  adapter :files do
    register :instrumentation, ROM::Files::Plugins::Relation::Instrumentation, type: :relation
    register :contents, ROM::Files::Plugins::Schema::Contents, type: :schema
    register :mime, ROM::Files::Plugins::Schema::Mime, type: :schema
    register :shebang, ROM::Files::Plugins::Schema::Shebang, type: :schema
    register :stat, ROM::Files::Plugins::Schema::Stat, type: :schema
  end
  register :gem, ROM::Files::Plugins::Configuration::Gem, type: :configuration
end
