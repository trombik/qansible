require "simplecov"
SimpleCov.start
require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rspec/core/rake_task"
require "pathname"
require "qansible_qa"
require "qansible_init"
require "qansible"

ENV["ANSIBLE_QA_SILENT"] = "y"

RSpec.configure do |config|
  config.before(:example) { @fixtures_dir = Pathname.new("spec") + "unit" + "fixtures" }
  config.pattern = "spec/(?:unit|integration)/specs/**/*_spec.rb"
end
