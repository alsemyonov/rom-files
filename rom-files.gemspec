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

  spec.add_runtime_dependency 'mime-types', '~> 3.1'
  spec.add_runtime_dependency 'rom', '~> 4.1'

  # Extensions
  spec.add_development_dependency 'kramdown'
  spec.add_development_dependency 'parser'
  spec.add_development_dependency 'xdg'

  # Dependencies
  spec.add_development_dependency 'bundler'

  # Pipeline
  spec.add_development_dependency 'rake', '~> 12.2'

  # Testing
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop', '~> 0.51'
  spec.add_development_dependency 'simplecov', '~> 0.15'

  # Documentation
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'yard-junk'
  spec.add_development_dependency 'yardcheck'
end
