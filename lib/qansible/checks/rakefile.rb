require "open3"

class QAnsible
  class Check
    class Rakefile < QAnsible::Check::Base

      def initialize
        super(:path => "Rakefile")
      end

      def check
        must_exist
        should_be_identical
        must_accept_test_as_target
      end

      def must_accept_test_as_target
        command = "rake -T"
        Dir.chdir(QAnsible::Check::Base.root) do
          Open3.popen3(command) do |stdin, stdout, stderr, process|
            status = process.value.exitstatus
            case status
            when 0
              stdout.each_line do |line|
                if line.split("#").first !~ /^rake\s+test\b/
                  crit "`%s` does not accept target `test`. it must accept the target. add the target to the file" % [ @path ]
                end
              end
            else
              crit "command `%s` failed: status: %d stdout: %s stderr: %s" % [ command, status, stdout.read, stderr.read ]
            end
          end
        end
      end

    end
  end
end
