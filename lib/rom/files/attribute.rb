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
        return type[pathname.relative_path_from(root)] if relative?
        return type[pathname.read] if data?
        return type[pathname.stat] if stat?
        return type[pathname.stat.send(stat_property)] if stat_property?
        return type[processor.(pathname)] if processor?
        type[pathname]
      end

      # @return [Boolean]
      def stat?
        meta[:__stat__].is_a?(TrueClass)
      end

      # @return [Symbol]
      def stat_property
        return nil if stat?
        meta[:__stat__]
      end

      # @return [Boolean]
      def stat_property?
        !stat? && meta[:__stat__]
      end

      # @return [Boolean]
      def content?
        meta[:content].is_a?(TrueClass)
      end

      # @return [Boolean]
      def data?
        meta[Files::DATA].is_a?(TrueClass)
      end

      # @return [Boolean]
      def processor?
        meta[:__proc__]
      end

      # @return [#call]
      def processor
        meta[:__proc__].respond_to?(:call) ? meta[:__proc__] : meta[:__proc__].to_proc
      end

      # @return [Boolean]
      def relative?
        meta[:relative]
      end

      memoize :stat?, :stat_property?, :content?, :data?, :processor?, :processor, :relative?
    end
  end
end
