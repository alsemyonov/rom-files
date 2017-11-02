# frozen_string_literal: true

require 'dry/types/pathname'
require 'rom'

require 'rom/files/version'
require 'rom/files/gateway'
require 'rom/files/relation'

ROM.register_adapter :files, ROM::Files
