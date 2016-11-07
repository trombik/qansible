require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'pathname'

fixtures_dir = Pathname.new('spec') + 'unit' + 'fixtures'

task :default => :spec

desc "Run unit tests"
task :spec => [ 'clean', 'spec:setup', 'spec:unit' ]

namespace :spec do
  RSpec::Core::RakeTask.new("unit") do |task|
    task.pattern = "spec/unit/specs/**/*_spec.rb"
  end

  desc "setup test environment"
  task :setup do
    Dir.chdir(fixtures_dir) do
      sh "ansible-role-init ansible-role-latest"
    end
  end
end


task :clean do
  sh "rm -rf #{ fixtures_dir + 'ansible-role-latest' }"
end
