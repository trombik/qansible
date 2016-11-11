require "open3"
require "pathname"
require "qansible_qa/version"
require "qansible_qa/checks/base_check"
require "qansible_qa/checks/gemfile"
require "qansible_qa/checks/ackrc"
require "qansible_qa/checks/gitignore"
require "qansible_qa/checks/jenkinsfile"
require "qansible_qa/checks/hier"
require "qansible_qa/checks/travis"
require "qansible_qa/checks/meta_main_yml"
require "qansible_qa/checks/license"
require "qansible_qa/checks/kitchen_yml"
require "qansible_qa/checks/kitchen_local_yml"
require "qansible_qa/checks/rakefile"
require "qansible_qa/checks/readme"
require "qansible_qa/checks/changelog"
require "qansible_qa/checks/tasks"

class QAnsibleQA

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
        command = "ansible-role-init #{ Shellwords.escape(@role_name) }"
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
      QAnsibleQA::Check::Base.root(@root)
      QAnsibleQA::Check::Base.tmp(@tmp + @role_name)
      QAnsibleQA::Check::Base.verbose(@options[:verbose])
      begin
        checks = [ 
          QAnsibleQA::Check::README,
          QAnsibleQA::Check::Rakefile,
          QAnsibleQA::Check::Ackrc,
          QAnsibleQA::Check::Gemfile,
          QAnsibleQA::Check::CHANGELOG,
          QAnsibleQA::Check::Travis,
          QAnsibleQA::Check::Tasks,
          QAnsibleQA::Check::Hier,
          QAnsibleQA::Check::LICENSE,
          QAnsibleQA::Check::KitchenLocalYml,
          QAnsibleQA::Check::README,
          QAnsibleQA::Check::KitchenYml,
          QAnsibleQA::Check::Gitignore,
          QAnsibleQA::Check::Jenkinsfile,
          QAnsibleQA::Check::MetaMainYaml,
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
