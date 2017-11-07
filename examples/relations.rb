#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rom-files'

Types = ROM::Files::Types
configuration = ROM::Configuration.new(:files, Pathname(__dir__).dirname)

class Implementations < ROM::Files::Relation
  dataset { select('*.rb').recursive }
  schema :lib, as: :implementations do
    attribute :__FILE__, Types::Coercible::Pathname

    primary_key :__FILE__
  end
end

configuration.register_relation(Implementations)

class Specifications < ROM::Files::Relation
  dataset { select('*_spec.rb').recursive }
  schema :spec, as: :specifications do
    attribute :__FILE__, Types::Coercible::Pathname

    primary_key :__FILE__
  end
end

configuration.register_relation(Specifications)

class TemporaryFiles < ROM::Files::Relation
  dataset { recursive }
  schema :tmp, as: :temporary_files do
    attribute :__FILE__, Types::Coercible::Pathname

    primary_key :__FILE__
  end
end

configuration.register_relation(TemporaryFiles)

container = ROM.container(configuration)
p container

lib = container.relations[:implementations]
spec = container.relations[:specifications]
tmp = container.relations[:temporary_files]

puts "lib #=> #{lib.inspect}"
puts 'pluck(:to_s) #=>', lib.pluck(:to_s)
# p :to_a, lib.to_a
puts 'spec #=>', spec.pluck(:basename)

puts "tmp #=> #{tmp.to_a}"
