# frozen_string_literal: true

require 'rom/memory/dataset'
require 'rom/files/types'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module Filtering
        def self.included(other)
          super(other)
          other.module_eval do
            option :inside_paths, Types::Strict::Array.of(Types::Coercible::Pathname), default: proc { HERE }
            option :include_patterns, Types::Strict::Array.of(Types::Coercible::String), default: proc { ALL }
            option :exclude_patterns, Types::Strict::Array.of(Types::Coercible::String), default: proc { EMPTY_ARRAY }
            option :search_recursive, Types::Bool, default: proc { true }
            option :ftype, Types::Strict::Array.of(Types::FileType), default: proc { FILES }
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

        # @!attribute [r] search_recursive
        #   Whether to search for files only in specific directory/ies or recursively
        #   @return [Boolean]

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
          with(inside_paths: paths)
        end

        # @return [Dataset]
        def inside_append(*paths)
          with(inside_paths: (inside_paths + paths).uniq)
        end

        # @return [Dataset]
        def recursive
          with(search_recursive: true)
        end

        # @return [Dataset]
        def not_recursive
          with(search_recursive: false)
        end

        # @return [Array<Pathname>]
        def search_patterns
          inside_paths.inject([]) do |result, path|
            path = path.join('**') if search_recursive
            result + include_patterns.map do |pattern|
              path.join(pattern)
            end
          end
        end

        # @return [Boolean]
        def recursive?
          search_recursive ||
            inside_paths.all? { |path| path.to_s =~ RECURSIVE_EXPRESSION } ||
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
