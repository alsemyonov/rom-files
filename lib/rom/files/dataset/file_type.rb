# frozen_string_literal: true

require 'rom/memory/dataset'
require_relative '../constants'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module FileType
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
        def files
          with(ftype: FILES)
        end

        # @return [Dataset]
        def directories
          with(ftype: DIRECTORIES)
        end
      end
    end
  end
end
