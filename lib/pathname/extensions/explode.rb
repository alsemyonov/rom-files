# frozen_string_literal: true

require 'pathname/extensions'

class Pathname
  module Extensions
    module Explode
      def self.included(host)
        super
        host.load_extensions :constants
      end

      # Explode a path into individual components
      #
      # @return [Array<Pathname>]
      #
      # @see Pathmap#pathmap Used by `#pathmap`
      def explode
        head, tail = split
        return [self] if head == self
        return [tail] if head == HERE || tail == ROOT
        return [head, tail] if head == ROOT
        head.explode + [tail]
      end
    end
  end
end
