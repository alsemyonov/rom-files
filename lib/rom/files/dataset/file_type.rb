# frozen_string_literal: true

require 'rom/memory/dataset'
require_relative '../constants'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module FileType
        # @param other [Module]
        def self.included(other)
          super(other)
          other.module_eval do
            option :ftype, Types::Strict::Array.of(Types::FileType), default: proc { FILES }
          end
        end

        # @!attribute [r] ftype
        #   Specify ftype that should be selected
        #   @see Types::FileType
        #   @return [Array<String>]

        # @return [Dataset]
        def typed(*types)
          with(ftype: types)
        end

        # @return [Dataset]
        def files
          typed(FILES)
        end

        # @return [Dataset]
        def directories
          typed(DIRECTORIES)
        end
      end
    end
  end
end
