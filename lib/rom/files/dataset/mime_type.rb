# frozen_string_literal: true

module ROM
  module Files
    class Dataset
      module MimeType
        def initialize(path, mime_type: nil, includes: ['*'], **options)
          if mime_type
            includes = includes.inject([]) do |result, pattern|
              result + mime_type.extensions.map { |ext| "#{pattern}.#{ext}" }
            end
          end
          super(path, mime_type: mime_type, includes: includes, **options)
        end

        # @param type [String]
        # @return [Dataset]
        def mime(type = nil)
          with(mime_type: type)
        end
      end
    end
  end
end
