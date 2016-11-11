require "qansible/commands/qa/options"
require "qansible/commands/qa/parser"
require "qansible/checks"
require "shellwords"

class Qansible
  class Command
    class QA
      def initialize(options)
        @options = options
      end

      def all_check_classes
        [
          QAnsible::Check::README,
          QAnsible::Check::Rakefile,
          QAnsible::Check::Ackrc,
          QAnsible::Check::Gemfile,
          QAnsible::Check::CHANGELOG,
          QAnsible::Check::Travis,
          QAnsible::Check::Tasks,
          QAnsible::Check::Hier,
          QAnsible::Check::LICENSE,
          QAnsible::Check::KitchenLocalYml,
          QAnsible::Check::README,
          QAnsible::Check::KitchenYml,
          QAnsible::Check::Gitignore,
          QAnsible::Check::Jenkinsfile,
          QAnsible::Check::MetaMainYaml
        ]
      end

      def create_reference_tree(dir)
        Dir.chdir(dir) do
          command = "ansible-role-init %s" % [ Shellwords.escape(@options.role_name) ]
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

          QAnsible::Check::Base.root(@options.directory)
          QAnsible::Check::Base.tmp(tmpdir + @options.role_name)
          QAnsible::Check::Base.verbose(@options.verbose)
          begin
            all_check_classes.each do |c|
              instance = c.new
              instance.check
              warnings += instance.number_of_warnings
            end
          rescue StandardError => e
            puts "The check ended with exception `%s`" % [ e ]
            puts e.message
            puts e.backtrace if @options[:verbose]
            @failed = true
          end

          if @failed
            puts "Number of warnings: %d" % [ warnings ]
            exit 1
          else
            puts "Number of warnings: %d" % [ warnings ]
            puts "Successfully finished."
          end
        end
      end
    end
  end
end
