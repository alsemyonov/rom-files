# frozen_string_literal: true

require 'rom/memory/dataset'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module Sorting
        def self.included(other)
          super(other)
          other.module_eval do
            option :sorting, Types::Symbol.optional,
                   default: proc { nil }
          end
        end

        # @!attribute [r] sorting
        #   @return [Symbol, Proc, nil]

        # @return [Dataset]
        def sort(sorting = :to_s)
          with(sorting: sorting)
        end
      end
    end
  end
end
