require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "pathname"

fixtures_dir = Pathname.new("spec") + "unit" + "fixtures"
ENV["PATH"] = ENV["PATH"] + ":" + Pathname.pwd.join("exe").to_s
task :default => :spec

desc "Run tests"
task :spec => [ "clean", "spec:setup", "spec:unit", "spec:integration", "spec:rubocop" ]

namespace :spec do
  RSpec::Core::RakeTask.new("unit") do |task|
    task.pattern = "spec/unit/specs/**/*_spec.rb"
  end

  desc "Run intergration test"
  RSpec::Core::RakeTask.new("integration") do |task|
    task.pattern = "spec/integration/specs/**/*_spec.rb"
  end

  desc "Run rubocop"
  task :rubocop do
    sh "rubocop --display-cop-names --extra-details --display-style-guide"
  end

  desc "setup test environment"
  task :setup do

    sh "mkdir -p tmp"
    Dir.chdir(fixtures_dir) do
      sh "ansible-role-init.rb ansible-role-latest"
    end

    Dir.chdir("tmp") do
      sh "ansible-role-init.rb ansible-role-default"
    end

  end
end


task :clean do
  sh "rm -rf #{ fixtures_dir + 'ansible-role-latest' }"
  sh "rm -rf tmp/*"
end
