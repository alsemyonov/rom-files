# frozen_string_literal: true

module ROM
  module Files
    class Dataset
      # @param [Pathname] path
      # @param [Hash] options
      # @option options [Array<String>] :select (['*'])
      # @option options [Bool] :sort
      def initialize(path, options = {})
        @path = path
        @options = options
        @options[:select] ||= ['*']
      end

      # @return [Dataset]
      def select(*patterns)
        self.class.new(@path, @options.merge(select: patterns))
      end

      # @return [Dataset]
      def sort
        self.class.new(@path, @options.merge(sort: true))
      end

      def each(&block)
        to_a.each(&block)
      end

      # @return [Array<Hash{Symbol => Pathname, String}>]
      def to_a
        matches = @options[:select].reduce([]) do |result, path|
          result + Pathname.glob(@path.join(path))
        end
        matches = matches.sort if @options[:sort]

        matches.map do |path|
          {
            name: path.basename.to_s,
            path: path
          }
        end
      end
    end
  end
end
