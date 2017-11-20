# frozen_string_literal: true

require 'pathname'
require 'rom/attribute'
require_relative 'constants'

module ROM
  module Files
    class Attribute < ROM::Attribute
      # @param [Pathname] pathname
      # @return [Object]
      def call(pathname) # rubocop:disable Metrics/AbcSize
        return type[pathname.read] if meta[Files::DATA]
        return type[pathname.stat] if meta[:__stat__].is_a?(TrueClass)
        return type[pathname.stat.send(meta[:__stat__])] if meta[:__stat__]
        return type[meta[:__proc__].(pathname)] if meta[:__proc__]
        type[pathname]
      end
    end
  end
end
