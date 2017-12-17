# frozen_string_literal: true

require 'rom/memory/dataset'
require 'rom/files/types'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module ExcludePatterns
        def self.included(other)
          super(other)
          other.module_eval do
            option :exclude_patterns, Types::Strict::Array.of(Types::Coercible::String), default: proc { EMPTY_ARRAY }
          end
        end

        # @!group Reading

        # @!attribute [r] exclude_patterns
        #   Array of filename patterns to be rejected
        #   @return [Array<String>]

        # @return [Dataset]
        def reject(*patterns)
          with(exclude_patterns: patterns.uniq)
        end

        # @return [Dataset]
        def reject_append(*patterns)
          with(exclude_patterns: (exclude_patterns + patterns).uniq)
        end
      end
    end
  end
end
