# frozen_string_literal: true

require 'pathname/extensions'

class Pathname
  module Extensions
    # Changes extension of file
    module Ext
      def self.included(host)
        host.load_extensions :constants
        super
      end

      # Replace the file extension with +new_extension+.
      # If there is no extension on the string, append the new extension to the end.
      # If the new extension is not given, or is the empty string, remove any existing extension.
      # @param new_extension [String]
      # @return [Pathname]
      def ext(new_extension = EMPTY_STRING)
        return dup if [HERE, UPPER].include? self
        unless new_extension == EMPTY_STRING
          new_extension = '.' + new_extension unless new_extension.match?(/^\./)
        end
        sub_ext(new_extension)
      end
    end
  end
end
