# frozen_string_literal: true

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
end

task doc: %i[doc:default]

desc 'Run CI tasks'
task ci: %i[spec style doc doc:junk]

task default: :ci
