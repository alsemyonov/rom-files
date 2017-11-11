# frozen_string_literal: true

require 'rom/commands/update'

module ROM
  module Files
    module Commands
      class Update < ROM::Commands::Update
        adapter :files

        def execute(attributes)
          relation.each { |tuple| source.update(tuple, attributes) }
        end
      end
    end
  end
end
