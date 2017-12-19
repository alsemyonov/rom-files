# frozen_string_literal: true

require 'pathname'
require 'rom/attribute'
require_relative 'constants'

module ROM
  module Files
    class Attribute < ROM::Attribute
      # @param [Pathname] pathname
      # @return [Object]
      def call(pathname, root: nil)
        return type[pathname.relative_path_from(root)] if meta[:relative]
        return type[pathname.read] if meta[Files::DATA]
        return type[pathname.stat] if meta[:__stat__].is_a?(TrueClass)
        return type[pathname.stat.send(meta[:__stat__])] if meta[:__stat__]

        if meta[:__proc__]
          proc = meta[:__proc__].respond_to?(:call) ? meta[:__proc__] : meta[:__proc__].to_proc
          return type[proc.(pathname)]
        end
        type[pathname]
      end
    end
  end
end
