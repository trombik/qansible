require "open3"
require "pathname"
require "ansible_qa/version"
require "ansible_qa/checks/base_check"
require "ansible_qa/checks/gemfile"
require "ansible_qa/checks/ackrc"
require "ansible_qa/checks/gitignore"
require "ansible_qa/checks/jenkinsfile"
require "ansible_qa/checks/hier"
require "ansible_qa/checks/travis"
require "ansible_qa/checks/meta_main_yml"
require "ansible_qa/checks/license"
require "ansible_qa/checks/kitchen_yml"
require "ansible_qa/checks/kitchen_local_yml"
require "ansible_qa/checks/rakefile"
require "ansible_qa/checks/readme"
require "ansible_qa/checks/changelog"
require "ansible_qa/checks/tasks"

class AnsibleQA

  attr_reader :options, :role_name, :failed

  def initialize(opts = {})
    default = {
      :root => Pathname.new(Dir.pwd),
      :verbose => false,
    }
    if opts.has_key?(:root)
      if ! opts[:root].is_a?(Pathname)
        opts[:root] = Pathname.new(opts[:root])
      end
    end

    @options = default.merge(opts)
    @role_name = @options[:root].expand_path.basename
    @root = @options[:root]
    @failed = false
  end

  def root(path = nil)
    if path
      @root = path.is_a?(Pathname) ? path : Pathname.new(path)
    end
    @root
  end

  def tmp(path = nil)
    if path
      @tmp = path.is_a?(Pathname) ? path : Pathname.new(path)
    end
    @tmp
  end

  def run

    # rubocop:disable Metrics/BlockLength
    Dir.mktmpdir do |tmp|
      @tmp = Pathname.new(tmp)
      Dir.chdir(@tmp) do
        command = "ansible-role-init.rb #{ Shellwords.escape(@role_name) }"
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

      warnings = 0
      AnsibleQA::Check::Base.root(@root)
      AnsibleQA::Check::Base.tmp(@tmp + @role_name)
      AnsibleQA::Check::Base.verbose(@options[:verbose])
      begin
        checks = [ 
          AnsibleQA::Check::README,
          AnsibleQA::Check::Rakefile,
          AnsibleQA::Check::Ackrc,
          AnsibleQA::Check::Gemfile,
          AnsibleQA::Check::CHANGELOG,
          AnsibleQA::Check::Travis,
          AnsibleQA::Check::Tasks,
          AnsibleQA::Check::Hier,
          AnsibleQA::Check::LICENSE,
          AnsibleQA::Check::KitchenLocalYml,
          AnsibleQA::Check::README,
          AnsibleQA::Check::KitchenYml,
          AnsibleQA::Check::Gitignore,
          AnsibleQA::Check::Jenkinsfile,
          AnsibleQA::Check::MetaMainYaml,
        ]
        checks.each do |c|
          instance = c.new
          instance.check
          warnings += instance.number_of_warnings
        end
      rescue StandardError => e
        puts "The check ended with exception `%s`" % [ e ]
        puts e.backtrace if @options[:verbose]
        @failed = true
      ensure
      end

      if @failed
        exit 1
      else
        puts "Number of warnings: %d" % [ warnings ]
        puts "Successfully finished."
      end

    end
    # rubocop:enable Metrics/BlockLength
  end
end
