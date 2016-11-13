require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "pathname"

fixtures_dir = Pathname.new("spec") + "unit" + "fixtures"
ENV["PATH"] = ENV["PATH"] + ":" + Pathname.pwd.join("exe").to_s
task :default => :spec

desc "Run tests"
task :spec => [ "clean", "spec:setup", "spec:test", "spec:rubocop" ]

namespace :spec do
  RSpec::Core::RakeTask.new("test") do |task|
    task.pattern = "spec/*/specs/**/*_spec.rb"
  end

  desc "Run rubocop"
  task :rubocop do
    sh "rubocop --display-cop-names --extra-details --display-style-guide"
  end

  desc "setup test environment"
  task :setup do
    sh "mkdir -p tmp"
    sh "qansible init --directory=#{ fixtures_dir } ansible-role-latest"
  end
end

task :clean do
  sh "rm -rf #{ fixtures_dir + 'ansible-role-latest' }"
  sh "rm -rf tmp/*"
  sh "rm -rf pkg/*"
end
