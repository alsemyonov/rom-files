# frozen_string_literal: true

require 'rom/memory/dataset'
require 'rom/files/constants'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module Paths
        def self.included(other)
          super(other)
          other.extend ClassInterface
        end

        module ClassInterface
          # @return [Proc]
          def row_proc
            ->(path) { Hash[ID => path] }
          end
        end

        # @return [Array<Hash{Symbol => Pathname, String}>]
        def data
          pluck(row_proc)
        end

        alias to_a data
        alias to_ary to_a

        # @!attribute [r] row_proc
        #   @return [Proc]

        # @return [Array<Pathname>]
        def paths
          patterns = inside_paths.inject([]) do |result, path|
            result + include_patterns.map do |pattern|
              path.join(pattern)
            end
          end
          connection.search(patterns, exclude_patterns: exclude_patterns, sorting: sorting, path: path)
        end

        # Pluck values from a pathname property
        #
        # @overload pluck(field)
        #
        # @example Usage with Symbol
        #   users.pluck(:extname).uniq
        #   # %w[.rb .rbw]
        #
        # @param [#to_proc, nil] field A name of the property for extracting values from pathname
        #
        # @overload pluck { |pathname| ... }
        #
        # @example Usage with block
        #   users.pluck { |pathname| pathname.basename.to_s }
        #   # [1, 2, 3]
        #
        # @return [Array]
        #
        # @api public
        def pluck(field = nil, &block)
          block ||= field.to_proc
          paths.map(&block)
        end

        # Iterate over data using row_proc
        #
        # @return [Enumerator, Array] if block is not given
        #
        # @api private
        def each
          return to_enum unless block_given?
          paths.each { |tuple| yield(row_proc[tuple]) }
        end

        # @return [Integer]
        def count
          to_a.size
        end
      end
    end
  end
end