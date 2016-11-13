require "simplecov"
SimpleCov.start
require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rspec/core/rake_task"
require "pathname"
require "qansible"
require "shellwords"

ENV["QANSIBLE_SILENT"] = "y"

RSpec.configure do |config|
  config.before(:example) { @fixtures_dir = Pathname.new("spec") + "unit" + "fixtures" }
  config.pattern = "spec/(?:unit|integration)/specs/**/*_spec.rb"
end

def create_latest_tree
  fixtures_dir = Pathname.new("spec") + "unit" + "fixtures"
  system "qansible init --directory=%s ansible-role-latest" % [ Shellwords.escape(fixtures_dir) ]
end

def remove_latest_tree
  fixtures_dir = Pathname.new("spec") + "unit" + "fixtures"
  system "rm -rf %s/ansible-role-latest" % [ Shellwords.escape(fixtures_dir) ]
end
