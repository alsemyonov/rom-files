# frozen_string_literal: true

require 'forwardable'
require 'rom/initializer'
require 'rom/support/memoizable'
require 'rom/memory/dataset'

require_relative 'connection'
require_relative 'constants'
require_relative 'types'

require_relative 'dataset/exclude_patterns'
require_relative 'dataset/file_type'
require_relative 'dataset/include_patterns'
require_relative 'dataset/mime_type'
require_relative 'dataset/paths'
require_relative 'dataset/sorting'

module ROM
  module Files
    class Dataset < Memory::Dataset
      extend Forwardable

      include ExcludePatterns
      include FileType
      include IncludePatterns
      include MimeType
      include Paths
      include Sorting

      include Dry::Equalizer(:path, :include_patterns, :exclude_patterns, :sorting, :ftype, :mime_type)

      # @!method initialize(mime_type: nil, include_patterns: ['*'], exclude_patterns: [], sorting: nil)
      #   @param include_patterns [Array<String, #to_s>]
      #     array of patterns to be selected inside `path`, maps to {#include_patterns}
      #   @param exclude_patterns [Array<String, #to_s>]
      #     array of patterns to be rejected inside `path`, maps to {#exclude_patterns}
      #   @param sorting [Symbol, Proc, nil]
      #     see {#sorting}

      # @!attribute [r] connection
      #   @return [Connection]
      option :connection, default: proc { Connection.new }

      # @!attribute [r] path
      #   @return [Connection]
      option :path, Types::Coercible::Pathname, default: proc { connection.path }

      def at(path)
        with(path: Pathname(path))
      end

      def dig(path)
        with(path: self.path.join(path))
      end

      def up(level = 1)
        path = self.path
        level.times { path = path.dirname }
        with(path: path)
      end

      # @!method project(*names)
      # Project a dataset
      #
      # @param names [Array<Symbol>] A list of attribute names
      #
      # @return [Dataset]
      #
      # @api public

      # @!method join(*args)
      #
      # Join with other datasets
      #
      # @param args [Array<Dataset>] A list of dataset to join with
      #
      # @return [Dataset]
      #
      # @api public

      # @!method restrict(criteria = nil)
      # Restrict a dataset
      #
      # @param criteria [Hash] A hash with conditions
      #
      # @return [Dataset]
      #
      # @api public
    end
  end
end
