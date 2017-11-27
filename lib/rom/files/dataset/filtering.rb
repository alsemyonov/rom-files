# frozen_string_literal: true

require 'rom/memory/dataset'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module Filtering
        def self.included(other)
          super(other)
          other.module_eval do
            option :inside_paths, Types::Strict::Array.of(Types::Coercible::Pathname),
                   default: proc { HERE }

            option :include_patterns, Types::Strict::Array.of(Types::Coercible::String),
                   default: proc { ALL }

            option :exclude_patterns, Types::Strict::Array.of(Types::Coercible::String),
                   default: proc { EMPTY_ARRAY }
          end
        end

        # @!group Reading

        # @!attribute [r] inside_paths
        #   Array of glob patterns to select files inside
        #   @return [Array<String>]

        # @!attribute [r] include_patterns
        #   Array of glob patterns to be selected inside {#inside_paths}
        #   @return [Array<String>]

        # @!attribute [r] exclude_patterns
        #   Array of filename patterns to be rejected
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
        def inside(*prefixes)
          select(*prefixes.inject([]) do |result, prefix|
            result + include_patterns.map do |pattern|
              "#{prefix}/#{pattern}"
            end
          end)
        end

        # @return [Dataset]
        def recursive
          inside '**'
        end

        # @return [Boolean]
        def recursive?
          include_patterns.all? { |pattern| pattern =~ RECURSIVE_EXPRESSION }
        end

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
