# frozen_string_literal: true

require 'pathname'
require 'rom/attribute'

module ROM
  module Files
    class Attribute < ROM::Attribute
      # @param [Pathname] pathname
      # @return [Object]
      def call(pathname) # rubocop:disable Metrics/AbcSize
        return type[pathname.read] if meta[:__contents__]
        return type[pathname.stat] if meta[:__stat__].is_a?(TrueClass)
        return type[pathname.stat.send(meta[:__stat__])] if meta[:__stat__]
        type[pathname]
      end
    end
  end
end
