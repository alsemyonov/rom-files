# frozen_string_literal: true

require 'rom/commands/create'

module ROM
  module Files
    module Commands
      class Create < ROM::Commands::Create
        adapter :files

        # @param tuples [Array<Hash>]
        def execute(tuples)
          tuples.each { |tuple| relation << tuple }
        end
      end
    end
  end
end
