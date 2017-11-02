# frozen_string_literal: true

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:style) do |task|
  task.options << '--display-cop-names'
end

require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new(:doc)

desc 'Run CI tasks'
task ci: %i[spec style doc]

task default: :ci
