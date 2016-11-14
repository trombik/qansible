require "qansible/checks"
require "shellwords"
require "tmpdir"

module Qansible
  class Command
    class QA < Qansible::Command::Base
      def initialize(options)
        @options = options
        super
      end

      def all_check_classes
        [
          Qansible::Check::README,
          Qansible::Check::Rakefile,
          Qansible::Check::Ackrc,
          Qansible::Check::Gemfile,
          Qansible::Check::CHANGELOG,
          Qansible::Check::Travis,
          Qansible::Check::Tasks,
          Qansible::Check::Hier,
          Qansible::Check::LICENSE,
          Qansible::Check::KitchenLocalYml,
          Qansible::Check::README,
          Qansible::Check::KitchenYml,
          Qansible::Check::Gitignore,
          Qansible::Check::Jenkinsfile,
          Qansible::Check::MetaMainYaml
        ]
      end

      def create_reference_tree(dir)
        Dir.chdir(dir) do
          command = "qansible init --quiet --directory=%s %s" % [ dir, Shellwords.escape(@options.role_name) ]
          Open3.popen3(command) do |_stdin, stdout, stderr, process|
            status = process.value.exitstatus
            if status.nonzero?
              warn "cannot run command: %s" % [ command ]
              warn "status: %s" % [ status ]
              warn "stdout: %s" % [ stdout.read ]
              warn "stderr: %s" % [ stderr.read ]
              exit 1
            end
          end
        end
      end

      def run
        Dir.mktmpdir do |d|
          tmpdir = Pathname.new(d)
          warnings = 0
          create_reference_tree(tmpdir)

          Qansible::Check::Base.root(@options.directory)
          Qansible::Check::Base.tmp(tmpdir + @options.role_name)
          Qansible::Check::Base.verbose(@options.verbose)
          begin
            all_check_classes.each do |c|
              instance = c.new
              instance.check
              warnings += instance.number_of_warnings
            end
          rescue StandardError => e
            error "The check ended with exception `%s`" % [ e ]
            error e.message
            error e.backtrace if @options[:verbose]
            @failed = true
          end

          if @failed
            error "Number of warnings: %d" % [ warnings ]
            exit 1
          else
            info "Number of warnings: %d" % [ warnings ]
            info "Successfully finished."
          end
        end
      end
    end
  end
end
