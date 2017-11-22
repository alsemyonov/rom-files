# frozen_string_literal: true

source 'https://rubygems.org'
git_source :github do |repo|
  "https://github.com/#{repo}"
end

gemspec

gem 'rom', '~> 4.1', github: 'rom-rb/rom', branch: :master
gem 'rom-sql', '~> 2.2', github: 'rom-rb/rom-sql', branch: :master

group :ide do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rake'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'terminal-notifier-guard'
end
