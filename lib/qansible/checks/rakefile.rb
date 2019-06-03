# frozen_string_literal: true

require "open3"

module Qansible
  class Check
    class Rakefile < Qansible::Check::Base
      def initialize
        super(path: "Rakefile")
      end

      def check
        must_exist
        should_be_identical
        must_accept_test_as_target
      end

      def must_accept_test_as_target
        command = "rake -T"
        Dir.chdir(Qansible::Check::Base.root) do
          Open3.popen3(command) do |_stdin, stdout, stderr, process|
            status = process.value.exitstatus
            case status
            when 0
              matched = false
              stdout.each_line do |line|
                matched = true if line =~ /^rake\s+test\b/
              end
              crit "`%s` does not accept target `test`. it must accept the target. add the target to the file" % [@path] unless matched
            else
              crit "command `%s` failed: status: %d stdout: %s stderr: %s" % [command, status, stdout.read, stderr.read]
            end
          end
        end
      end
    end
  end
end
