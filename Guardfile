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
  guard :rspec, cmd: 'bin/rspec', all_on_start: true, all_after_pass: true do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    rspec = dsl.rspec
    watch('.rspec') { rspec.spec_dir }
    watch('Gemfile.lock') { rspec.spec_dir }
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(%r{\A#{rspec.spec_dir}/(?:shared)/.+\.rb\Z}) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    notification :tmux, display_message: true if ENV.key?('TMUX')
  end

  guard :rubocop, cli: '--auto-correct' do
    # run rubocop on modified file
    watch(%r{\Alib/.+\.rb\Z})
    watch(%r{\Aspec/.+\.rb\Z})
  end

  guard :shell do
    command = 'bin/yard doc --use-cache'
    watch(%r{\Alib/.+\.rb\Z}) { |m| `#{command} #{m}` }
    watch(/\A.+\.md\Z/) { |m| `#{command} #{m}` }
    watch('.yardopts') { `#{command}` }
  end
end
