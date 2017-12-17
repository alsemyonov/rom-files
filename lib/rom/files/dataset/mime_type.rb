# frozen_string_literal: true

require 'rom/memory/dataset'
require_relative '../constants'

module ROM
  module Files
    class Dataset < Memory::Dataset
      module MimeType
        def self.included(other)
          super(other)
          other.module_eval do
            option :mime_type, Types::MimeType.optional,
                   default: -> { nil }

            prepend Initializer
          end
        end

        module Initializer
          def initialize(data = [], mime_type: nil, include_patterns: ALL, **options)
            if mime_type && include_patterns.all? { |pattern| pattern.to_s !~ /\./ }
              include_patterns = include_patterns.inject([]) do |result, pattern|
                result + mime_type.extensions.map { |ext| "#{pattern}.#{ext}" }
              end
            end
            super(data, mime_type: mime_type, include_patterns: include_patterns, **options)
          end
        end

        # @!attribute [r] mime_type
        #   MIME-type of files to include
        #   @return [MIME::Type?]

        # @param type [String, nil]
        # @return [Dataset]
        def mime(type = nil)
          type = Types::MimeType[type] if type
          with(mime_type: type)
        end
      end
    end
  end
end
