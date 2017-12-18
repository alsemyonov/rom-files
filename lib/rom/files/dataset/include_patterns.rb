# frozen_string_literal: true

require 'rom/memory/dataset'
require 'rom/files/types'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module IncludePatterns
        def self.included(other)
          super(other)
          other.module_eval do
            option :include_patterns, Types::Strict::Array.of(Types::Coercible::String), default: proc { ALL }
          end
        end

        # @!group Reading

        # @!attribute [r] include_patterns
        #   Array of glob patterns to be selected inside {#path}
        #   @return [Array<String>]

        # @return [Dataset]
        def select(*patterns)
          with(include_patterns: patterns.uniq)
        end

        # @return [Dataset]
        def select_append(*patterns)
          with(include_patterns: (include_patterns + patterns).uniq)
        end

        # @return [Dataset]
        def inside(*paths)
          paths = paths.map { |path| Pathname(path) }
          patterns = include_patterns.inject([]) { |result, pattern| result + paths.map { |path| path.join(pattern) } }
          with(include_patterns: patterns)
        end

        # @return [Dataset]
        def recursively
          inside('**')
        end

        # @return [Boolean]
        def recursive?
          include_patterns.all? { |pattern| pattern.to_s =~ RECURSIVE_EXPRESSION }
        end
      end
    end
  end
end
