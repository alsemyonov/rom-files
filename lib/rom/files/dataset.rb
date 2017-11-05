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

      RECURSIVE_PATTERN = '**/'
      RECURSIVE_EXPRESSION = /#{Regexp.escape(RECURSIVE_PATTERN)}/

      # @!method initialize(path, includes: ['*'], excludes: [], sort_by: nil)
      #   @param path [Pathname, #to_s]
      #     directory to search for files inside, maps to {#path}
      #   @param includes [Array<String, #to_s>]
      #     array of patterns to be selected inside `path`, maps to {#includes}
      #   @param excludes [Array<String, #to_s>]
      #     array of patterns to be rejected inside `path`, maps to {#excludes}
      #   @param sort_by [Symbol, Proc, nil]
      #     see {#sort_by}

      # @!attribute [r] path
      #   Path of directory containing related files
      #   @return [Pathname]
      param :path, Types::Coercible::Pathname

      # @!attribute [r] includes
      #   Array of glob patterns to be selected inside {#path}
      #   @return [Array<String>]
      option :includes, Types::Strict::Array.of(Types::Coercible::String),
             default: proc { %w[*] }

      # @!attribute [r] excludes
      #   Array of filename patterns to be rejected
      #   @return [Array<String>]
      option :excludes, Types::Strict::Array.of(Types::Coercible::String),
             default: proc { EMPTY_ARRAY }

      # @!attribute [r] sort_by
      #   @return [Proc?]
      option :sort_by, Types::Symbol.optional,
             default: proc { nil }

      include DataProxy
      include Dry::Equalizer(:path, :includes, :excludes, :sort_by)

      def self.row_proc
        ->(path) { { name: path.basename.to_s, path: path } }
      end

      # @!group Reading

      # @return [Dataset]
      def select(*patterns)
        with(includes: patterns)
      end

      # @return [Dataset]
      def reject(*patterns)
        with(excludes: patterns)
      end

      # @return [Dataset]
      def sort(sort_by = :to_s)
        with(sort_by: sort_by)
      end

      # @return [Dataset]
      def inside(prefix)
        select(*includes.map { |pattern| "#{prefix}/#{pattern}" })
      end

      # @return [Dataset]
      def recursive
        inside '**'
      end

      # @return [Boolean]
      def recursive?
        includes.all? { |pattern| pattern =~ RECURSIVE_EXPRESSION }
      end

      # @return [Array<Pathname>]
      def matches
        matches = includes.reduce([]) do |result, pattern|
          result + Pathname.glob(path.join(pattern))
        end
        matches = matches.reject do |match|
          excludes.any? do |pattern|
            match.fnmatch(pattern, File::FNM_EXTGLOB)
          end
        end
        matches = matches.sort_by(&sort_by) if sort_by
        matches
      end

      memoize :matches

      alias data matches

      # @return [Array<Hash{Symbol => Pathname, String}>]
      def call
        matches.map(&row_proc)
      end

      alias to_a call
      alias to_ary to_a
    end
  end
end
