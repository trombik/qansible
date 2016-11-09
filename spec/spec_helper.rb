$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rspec/core/rake_task"
require "pathname"
require "ansible_qa"
require "ansible_init"

ENV["ANSIBLE_QA_SILENT"] = "y"

RSpec.configure do |config|
  config.before(:example) { @fixtures_dir = Pathname.new("spec") + "unit" + "fixtures" }
  config.pattern = "spec/unit/specs/**/*_spec.rb"
end
