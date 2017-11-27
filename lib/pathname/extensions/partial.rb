# frozen_string_literal: true

require 'pathname/extensions'

class Pathname
  module Extensions
    module Partial
      def self.included(host)
        host.load_extensions :explode
        super
      end

      # Extract a partial path from the path.  Include +n+ directories from the
      # front end (left hand side) if +n+ is positive.  Include |+n+|
      # directories from the back end (right hand side) if +n+ is negative.
      def partial(n)
        dirs = dirname.explode
        partial_dirs =
          if n.positive?
            dirs[0...n]
          elsif n.negative?
            dirs.reverse[0...-n].reverse
          else
            HERE
          end
        Pathname(File.join(partial_dirs))
      end
    end
  end
end
