# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/files/version'

Gem::Specification.new do |spec|
  spec.name = 'rom-files'
  spec.version = ROM::Files::VERSION
  spec.authors = ['Héctor Ramón', 'Alex Semyonov']
  spec.email = %w[hector0193@gmail.com alex@cerebelo.info]

  spec.summary = 'File adapter for ROM'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/alsemyonov/rom-files'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rom', '~> 4.0.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 12.2'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.51'
  spec.add_development_dependency 'yard', '~> 0.9'
end
