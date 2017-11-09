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
      include Memoizable
      include Filtering
      prepend MimeType
      include DataProxy
      include Dry::Equalizer(:path, :mime_type, :includes, :excludes, :sort_by)

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

      # @!attribute [r] sort_by
      #   @return [Symbol, Proc, nil]
      option :sort_by, Types::Symbol.optional,
             default: proc { nil }

      # @return [Proc]
      def self.row_proc
        ->(path) do
          {
            __FILE__: path,
            __contents__: path.read
          }
        end
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
          match.directory? || excludes.any? do |pattern|
            match.fnmatch(pattern, File::FNM_EXTGLOB)
          end
        end
        matches = matches.sort_by(&sort_by) if sort_by
        matches
      end

      memoize :matches

      alias data matches

      def map(field = nil, &block)
        # block ||= ->(hash) { hash[field] }
        block ||= field ? field.to_proc : row_proc
        matches.map(&block)
      end

      alias pluck map

      # @return [Array<Hash{Symbol => Pathname, String}>]
      def call
        map(&row_proc)
      end

      alias to_a call
      alias to_ary to_a

      # @return [Integer]
      def count
        to_a.size
      end
    end
  end
end
