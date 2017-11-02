# frozen_string_literal: true

notification :terminal_notifier if `uname`.match?(/Darwin/)

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'rspec', all_on_start: true, all_after_pass: true do
    # run all specs if Gemfile.lock is modified
    watch('Gemfile.lock') { 'spec' }

    # run all specs if any library code is modified
    watch(%r{\Alib/.+\.rb\Z}) { 'spec' }

    # run all specs if supporting files are modified
    watch('spec/spec_helper.rb') { 'spec' }
    watch(%r{\Aspec/(?:lib|support|shared)/.+\.rb\Z}) { 'spec' }

    # run a spec if it is modified
    watch(%r{\Aspec/(?:unit|integration)/.+_spec\.rb\Z})

    notification :tmux, display_message: true if ENV.key?('TMUX')
  end

  guard :rubocop do
    # run rubocop on modified file
    watch(%r{\Alib/.+\.rb\Z})
    watch(%r{\Aspec/.+\.rb\Z})
  end
end

guard :rake, task: 'doc' do
  watch(%r{\Alib/.+\.rb\Z})
  watch(/\A.+\.md\Z/)
  watch 'Rakefile'
  watch '.yardopts'
end
