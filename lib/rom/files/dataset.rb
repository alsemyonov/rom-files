# frozen_string_literal: true

require 'rom/data_proxy'
require 'rom/initializer'
require 'rom/support/memoizable'
require_relative 'constants'
require_relative 'types'
require_relative 'dataset/filtering'
require_relative 'dataset/mime_type'

module ROM
  module Files
    class Dataset
      extend Initializer

      prepend MimeType

      include Dry::Equalizer(:path, :mime_type, :includes, :excludes, :sorting)
      include Enumerable
      include Filtering

      # @!method initialize(path, mime_type: nil, includes: ['*'], excludes: [], sorting: nil)
      #   @param path [Pathname, #to_s]
      #     directory to search for files inside, maps to {#path}
      #   @param includes [Array<String, #to_s>]
      #     array of patterns to be selected inside `path`, maps to {#includes}
      #   @param excludes [Array<String, #to_s>]
      #     array of patterns to be rejected inside `path`, maps to {#excludes}
      #   @param sorting [Symbol, Proc, nil]
      #     see {#sorting}

      # @!attribute [r] path
      #   Path of directory containing related files
      #   @return [Pathname]
      param :path, Types::Coercible::Pathname

      # @!attribute [r] mime_type
      #   MIME-type of files to include
      #   @return [MIME::Type?]
      option :mime_type, Types::MimeType.optional,
             default: -> { nil }

      # @!attribute [r] includes
      #   Array of glob patterns to be selected inside {#path}
      #   @return [Array<String>]
      option :includes, Types::Strict::Array.of(Types::Coercible::String),
             default: proc { ALL }

      # @!attribute [r] excludes
      #   Array of filename patterns to be rejected
      #   @return [Array<String>]
      option :excludes, Types::Strict::Array.of(Types::Coercible::String),
             default: proc { EMPTY_ARRAY }

      # @!attribute [r] sorting
      #   @return [Symbol, Proc, nil]
      option :sorting, Types::Symbol.optional,
             default: proc { nil }

      # @!attribute [r] row_proc
      #   @return [Proc]
      option :row_proc,
             default: proc { self.class.row_proc }

      # @!attribute [r] connection
      #   @return [Connection]
      option :connection,
             default: proc { Connection.new(path) }

      # @return [Proc]
      def self.row_proc
        ->(path) { { __FILE__: path } }
      end

      # @return [Boolean]
      def recursive?
        includes.all? { |pattern| pattern =~ RECURSIVE_EXPRESSION }
      end

      # @return [Array<Pathname>]
      def files
        connection.search(includes, excludes: excludes, sorting: sorting, path: path)
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

      # Project a dataset
      #
      # @param [Array<Symbol>] names A list of attribute names
      #
      # @return [Dataset]
      #
      # @api public
      def project(*names)
        map { |tuple| tuple.select { |key| names.include?(key) } }
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
