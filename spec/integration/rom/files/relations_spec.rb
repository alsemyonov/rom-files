#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rom-files'
require 'rspec'

RSpec.example_group ROM::Files::Relation do
  Files = ROM::Files
  Types = Files::Types

  class Implementations < ROM::Files::Relation
    dataset { select('*.rb').recursive }
    schema :lib, as: :implementations do
      attribute Files::ID, Types::Coercible::Pathname

      primary_key Files::ID
    end
  end

  class Specifications < ROM::Files::Relation
    dataset { select('*_spec.rb').recursive }
    schema :spec, as: :specifications do
      attribute Files::ID, Types::Path
    end
  end

  class TempFiles < ROM::Files::Relation
    dataset { recursive }
    schema :tmp, as: :temporary_files do
      attribute Files::ID, Types::Pathname.meta(primary_key: true)
    end
  end

  let(:configuration) do
    ROM::Configuration.new(:files, Pathname(__dir__).dirname) do |config|
      config.register_relation(Implementations)
      config.register_relation(Specifications)
      config.register_relation(TempFiles)
    end
  end
  let(:container) { ROM.container(configuration) }

  example 'Retrieving relations' do
    p container

    lib = container.relations[:implementations]
    spec = container.relations[:specifications]
    tmp = container.relations[:temporary_files]

    expect(lib).to be_a Implementations
    expect(spec).to be_a Specifications
    expect(tmp).to be_a TempFiles

    puts "lib #=> #{lib.inspect}"
    puts 'pluck(:to_s) #=>', lib.pluck(:to_s)
    # p :to_a, lib.to_a
    puts 'spec #=>', spec.pluck(:basename)

    puts "tmp #=> #{tmp.to_a}"
  end
end

require 'rspec/autorun' if $PROGRAM_NAME == __FILE__
