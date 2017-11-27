# frozen_string_literal: true

require 'rom/data_proxy'
require 'rom/initializer'
require 'rom/support/memoizable'
require_relative 'constants'
require_relative 'types'
require_relative 'dataset/filtering'
require_relative 'dataset/mime_type'
require_relative 'dataset/selecting'
require_relative 'dataset/sorting'

module ROM
  module Files
    class Dataset
      extend Initializer

      include Dry::Equalizer(:path, :mime_type, :include_patterns, :exclude_patterns, :sorting)
      include Enumerable
      include Filtering
      include MimeType
      include Selecting
      include Sorting

      # @!method initialize(path, mime_type: nil, include_patterns: ['*'], exclude_patterns: [], sorting: nil)
      #   @param path [Pathname, #to_s]
      #     directory to search for files inside, maps to {#path}
      #   @param include_patterns [Array<String, #to_s>]
      #     array of patterns to be selected inside `path`, maps to {#include_patterns}
      #   @param exclude_patterns [Array<String, #to_s>]
      #     array of patterns to be rejected inside `path`, maps to {#exclude_patterns}
      #   @param sorting [Symbol, Proc, nil]
      #     see {#sorting}

      # @!attribute [r] path
      #   Path of directory containing related files
      #   @return [Pathname]
      param :path, Types::Coercible::Pathname

      # @!attribute [r] connection
      #   @return [Connection]
      option :connection,
             default: proc { Connection.new(path) }

      # Project a dataset
      #
      # @param names [Array<Symbol>] A list of attribute names
      #
      # @return [Dataset]
      #
      # @api public
      def project(*names)
        map { |tuple| tuple.select { |key| names.include?(key) } }
      end

      # Join with other datasets
      #
      # @param args [Array<Dataset>] A list of dataset to join with
      #
      # @return [Dataset]
      #
      # @api public
      def join(*args) # rubocop:disable Metrics/AbcSize
        left, right = args.size > 1 ? args : [self, args.first]

        join_map = left.each_with_object({}) { |tuple, h|
          others = right.to_a.find_all { |t| (tuple.to_a & t.to_a).any? }
          (h[tuple] ||= []).concat(others)
        }

        tuples = left.flat_map { |tuple|
          join_map[tuple].map { |other| tuple.merge(other) }
        }

        self.class.new(tuples, options)
      end

      # Restrict a dataset
      #
      # @param criteria [Hash] A hash with conditions
      #
      # @return [Dataset]
      #
      # @api public
      def restrict(criteria = nil)
        return find_all { |tuple| yield(tuple) } unless criteria

        find_all do |tuple|
          criteria.all? do |key, value|
            case value
            when Array then value.include?(tuple[key])
            when Regexp then tuple[key].match(value)
            else tuple[key].eql?(value)
            end
          end
        end
      end
    end
  end
end
