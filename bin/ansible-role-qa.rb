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

  @root_dir = @options[:dir].expand_path
  @role_name = @root_dir.expand_path.basename
  @number_of_warnings = 0
  @supported_platforms = []

  #info "Checking #{ @role_name }..."

  Dir.mktmpdir do |latest_tree_dir|

    @latest_tree_dir = Pathname.new(latest_tree_dir)
    @latest_tree_role_name = @role_name
    @tmp_root_dir = @latest_tree_dir + @latest_tree_role_name

    #debug "Created a temp dir: #{ @latest_tree_dir }"
    Dir.chdir @latest_tree_dir do
      command = "ansible-role-init #{ Shellwords.escape(@latest_tree_role_name) }"
      Open3.popen3(command) do |stdin, stdout, stderr, process|
        status = process.value.exitstatus
        if status != 0
          warn "cannot run command: #{ command }"
          warn "status: #{ status }"
          warn "stdout: #{ stdout.read }"
          warn "stderr: #{ stderr.read }"
          exit 1
        end
      end
    end

    Dir.chdir(@root_dir) do
      AnsibleQA::Base.root_dir(@root_dir)
      AnsibleQA::Base.tmp_root_dir(@tmp_root_dir)
      AnsibleQA::Base.check
      #info "Warnings in total: %d" % [ @number_of_warnings ]
      #info "All checks passed"
    end

  end

end

def new_main
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

new_main
