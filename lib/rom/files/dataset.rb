# frozen_string_literal: true

require 'rom/data_proxy'
require 'rom/initializer'
require 'rom/support/memoizable'
require_relative 'types'

module ROM
  module Files
    class Dataset
      extend Initializer
      include Memoizable

      # @!method initialize(path, query: ['*'], sort_by: nil)
      #   @param path [Pathname, #to_s]
      #     directory to search for `query` inside, maps to {#path}
      #   @param query [Array<String, #to_s>]
      #     array of patterns to be selected inside `path`, maps to {#query}
      #   @param sort_by [Symbol, Proc, nil]
      #     see {#sort_by}

      # @!attribute [r] path
      #   Path of directory containing related files
      #   @return [Pathname]
      param :path, Types::Coercible::Pathname

      # @!attribute [r] query
      #   Array of glob patterns to be selected inside {#path}
      #   @return [Array<String>]
      option :query, Types::Strict::Array.of(Types::Coercible::String),
             default: proc { ['*'] }

      # @!attribute [r] sort_by
      #   @return [Proc?]
      option :sort_by, Types::Symbol.optional, default: proc { nil }

      include DataProxy

      def self.row_proc
        ->(path) { { name: path.basename.to_s, path: path } }
      end

      # @!group Reading

      # @return [Dataset]
      def select(*query)
        with(query: query)
      end

      # @return [Dataset]
      def sort(sort_by = :to_s)
        with(sort_by: sort_by)
      end

      # @return [Array<Pathname>]
      def matches
        matches = query.reduce([]) do |result, pattern|
          result + Pathname.glob(path.join(pattern))
        end
        matches = matches.sort_by(&sort_by) if sort_by
        matches
      end

      memoize :matches

      alias data matches

      # @return [Array<Hash{Symbol => Pathname, String}>]
      def to_a
        matches.map(&row_proc)
      end

      alias to_ary to_a
    end
  end
end
