# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec

require 'rubocop/rake_task'
RuboCop::RakeTask.new :style do |task|
  task.options << '--display-cop-names'
end

namespace :doc do
  require 'yard'
  require 'yard/rake/yardoc_task'
  YARD::Rake::YardocTask.new :default

  require 'yard-junk'
  desc 'Check the junk in your YARD Documentation'
  task :junk do
    exit_code = YardJunk::Janitor.new.run.report(:text)
    exit exit_code unless exit_code.zero?
  end

  desc 'Check documentation with `yardcheck`'
  task :check do
    sh 'yardcheck --require rom-files --include lib --namespace ROM::Files --rspec spec'
  end
end

task doc: %i[doc:default]

desc 'Run CI tasks'
task ci: %i[spec doc doc:junk doc:check]

task default: :ci
