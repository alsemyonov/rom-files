# frozen_string_literal: true

require 'rom/memory/dataset'
require_relative '../constants'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module Path
        # @param other [Module]
        def self.included(other)
          super(other)
          other.module_eval do
            option :path, Types::Coercible::Pathname, default: proc { connection.path }
          end
        end

        # @!attribute [r] path
        #   @return [Connection]

        # @return [new Dataset]
        def at(path)
          with(path: Pathname(path))
        end

        # @return [new Dataset]
        def dig(path)
          with(path: self.path.join(path))
        end

        # @return [new Dataset]
        def up(level = 1)
          path = self.path
          level.times { path = path.dirname }
          with(path: path)
        end
      end
    end
  end
end
