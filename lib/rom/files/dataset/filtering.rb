# frozen_string_literal: true

module ROM
  module Files
    class Dataset
      module Filtering
        # @!group Reading

        # @return [Dataset]
        def select(*patterns)
          with(includes: patterns.uniq)
        end

        # @return [Dataset]
        def select_append(*patterns)
          with(includes: (includes + patterns).uniq)
        end

        # @return [Dataset]
        def inside(*prefixes)
          select(*prefixes.inject([]) do |result, prefix|
            result + includes.map do |pattern|
              "#{prefix}/#{pattern}"
            end
          end)
        end

        # @return [Dataset]
        def recursive
          inside '**'
        end

        # @return [Boolean]
        def recursive?
          includes.all? { |pattern| pattern =~ RECURSIVE_EXPRESSION }
        end

        # @return [Dataset]
        def reject(*patterns)
          with(excludes: patterns.uniq)
        end

        # @return [Dataset]
        def reject_append(*patterns)
          with(excludes: (excludes + patterns).uniq)
        end

        # @return [Dataset]
        def sort(sorting = :to_s)
          with(sorting: sorting)
        end
      end
    end
  end
end
