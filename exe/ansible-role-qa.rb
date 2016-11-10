#!/usr/bin/env ruby
require "optparse"
require "pathname"
require "shellwords"
require "open3"
require "tmpdir"
require "yaml"
require "erb"
require "ansible_qa"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

def main
  @options = {
    :verbose => false,
    :dir => Pathname.getwd,
    :self_test => false
  }
  OptionParser.new do |opts|

    opts.banner = "Usage: %s [options]" % [ Pathname.new(__FILE__).basename ]

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      @options[:verbose] = true
    end

    opts.on("-d", "--dir [dir]", "Run in `dir` instead of current directory") do |dir|
      @options[:dir] = Pathname.new(dir)
    end

    opts.on("--self-test", "Perform the QA test against a plain role created by ansible-role-init (NOT implemented)") do |dir|
      @options[:self_test] = true
    end

  end.parse!

  runner = AnsibleQA.new(
    :root => @options[:dir],
    :verbose => @options[:verbose],
  )
  runner.run
end

main
