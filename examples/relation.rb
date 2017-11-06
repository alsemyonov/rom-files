#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rom-files'

configuration = ROM::Configuration.new(:files, Pathname(__dir__).dirname)

class Implementations < ROM::Files::Relation
  dataset { select('*.rb').recursive }
  schema :lib do
  end
end

class Specifications < ROM::Files::Relation
  dataset { select('*_spec.rb').recursive }
  schema :spec do
  end
end

class TemporaryFiles < ROM::Files::Relation
  schema :tmp do
  end
end

configuration.register_relation(Implementations)
configuration.register_relation(Specifications)
configuration.register_relation(TemporaryFiles)

container = ROM.container(configuration)
p container

lib = container.relations[:lib]
spec = container.relations[:spec]
tmp = container.relations[:tmp]

puts "lib #=> #{lib.inspect}"
puts 'pluck(:to_s) #=>', lib.pluck(:to_s)
# p :to_a, lib.to_a
puts 'spec #=>', spec.pluck(:basename)

puts "tmp #=> #{tmp.inspect}"
