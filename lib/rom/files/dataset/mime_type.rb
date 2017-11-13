# frozen_string_literal: true

require_relative '../constants'

module ROM
  module Files
    class Dataset
      module MimeType
        def initialize(path, mime_type: nil, includes: ALL, **options)
          if mime_type && includes.all? { |pattern| pattern !~ /\./ }
            includes = includes.inject([]) do |result, pattern|
              result + mime_type.extensions.map { |ext| "#{pattern}.#{ext}" }
            end
          end
          super(path, mime_type: mime_type, includes: includes, **options)
        end

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
