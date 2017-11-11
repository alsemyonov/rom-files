# frozen_string_literal: true

require 'rom/commands/delete'

module ROM
  module Files
    module Commands
      class Delete < ROM::Commands::Delete
        adapter :files

        def execute
          relation.each { |tuple| source.delete(tuple) }
        end
      end
    end
  end
end
