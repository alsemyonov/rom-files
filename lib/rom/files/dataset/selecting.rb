# frozen_string_literal: true

module ROM
  module Files
    class Dataset
      module Selecting
        def self.included(other)
          super(other)
          other.module_eval do
            extend ClassInterface

            option :row_proc,
                   default: proc { self.class.row_proc }
          end
        end

        module ClassInterface
          # @return [Proc]
          def row_proc
            ->(path) { { ID => path } }
          end
        end

        # @!attribute [r] row_proc
        #   @return [Proc]

        # @return [Array<Pathname>]
        def files
          connection.search(include_patterns, exclude_patterns: exclude_patterns, sorting: sorting, path: path)
        end

        # Iterate over data using row_proc
        #
        # @return [Enumerator, Array] if block is not given
        #
        # @api private
        def each
          return to_enum unless block_given?
          files.each { |tuple| yield(row_proc[tuple]) }
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
          files.map(&block)
        end

        # @return [Array<Hash{Symbol => Pathname, String}>]
        def data
          pluck(row_proc)
        end
        alias to_a data
        alias to_ary to_a

        # @return [Integer]
        def count
          to_a.size
        end
      end
    end
  end
end
