require 'yaml'

class FileNotFound < StandardError
end

class CommandFailed < StandardError
end

module AnsibleQA
  module Checks
    class Base

      attr_reader :self, :number_of_warnings, :path, :tmp_root_dir, :root_dir

      def initialize(path)
        @number_of_warnings = 0
        @path = path
        @tmp_root_dir = AnsibleQA::Base.tmp_root_dir
        @root_dir = AnsibleQA::Base.root_dir
      end

      def must_exist

        result = File.exist?(@root_dir + @path)
        raise FileNotFound, "File `%s` must exist but not found" % [ @root_dir + @path ] if !result

      end

      def should_exist
        result = File.exist?(@root_dir + @path)
        warn "File `%s` should exist but not found" % [ @path ] if !result
      end

      def must_be_yaml

        hash = {}
        begin
          hash = YAML.load_file(@root_dir.to_s + @path.to_s)
        rescue Exception => e
          raise e
        end
        hash

      end

      def is_tty?

        STDOUT.isatty

      end

      def debug(msg)

        msg = "[debug] %s" % msg
        msg = colorize(msg, 'gray', 'black')
        STDOUT.puts(msg) if @options[:verbose]

      end

      def info(msg)

        msg = "[info] %s" % msg
        msg = colorize(msg, 'cyan', 'black')
        STDOUT.puts(msg)

      end

      def notice(msg)

        msg = "[notice] %s" % msg
        msg = colorize(msg, 'green', 'black')
        STDOUT.puts(msg)

      end

      def warn(msg)

        msg = "[warn] %s" % msg
        msg = colorize(msg, 'red', 'black')
        STDOUT.puts(msg) unless ENV['ANSIBLE_QA_SILENT']
        @number_of_warnings += 1

      end

      def crit(text)

        msg = "[crit] %s" % [ text ]
        msg = colorize(msg, 'red', 'black')
        STDOUT.puts(msg) unless ENV['ANSIBLE_QA_SILENT']
        exit 1

      end

      def colorize(text, color = "default", bgcolor = "default")
        retrun text if ! is_tty?
          colors = {
            "default" => "38",
            "black" => "30",
            "red" => "31",
            "green" => "32",
            "brown" => "33",
            "blue" => "34",
            "purple" => "35",
            "cyan" => "36",
            "gray" => "37",
            "dark gray" => "1;30",
            "light red" => "1;31",
            "light green" => "1;32",
            "yellow" => "1;33",
            "light blue" => "1;34",
            "light purple" => "1;35",
            "light cyan" => "1;36",
            "white" => "1;37"
          }
          bgcolors = {
            "default" => "0",
            "black" => "40",
            "red" => "41",
            "green" => "42",
            "brown" => "43",
            "blue" => "44",
            "purple" => "45",
            "cyan" => "46",
            "gray" => "47",
            "dark gray" => "100",
            "light red" => "101",
            "light green" => "102",
            "yellow" => "103",
            "light blue" => "104",
            "light purple" => "105",
            "light cyan" => "106",
            "white" => "107"
          }
          raise "colorize: unknown color: %s" % [ color ] if ! colors.has_key?(color)
          color_code = colors[color]
          raise "colorize: unknown bgcolor: %s" % [ bgcolor ] if ! colors.has_key?(bgcolor)
          bgcolor_code = bgcolors[bgcolor]
          return "\033[#{bgcolor_code};#{color_code}m#{text}\033[0m"
      end

      def should_be_identical
        check_is_identical(:action => :warn)
      end

      def must_be_identical
        check_is_identical(:action => :crit)
      end

      def check_is_identical(opts = {})

        default = {
          :action => :warn,
          :diff_option => "-Nu",
        }
        opts = default.merge(opts)

        original = @tmp_root_dir + @path
        target = @root_dir + @path
        (is_same, text) = _diff(original, target)
        
        if ! is_same
          case opts[:action]
          when :warn
            warn("File, %s is not identical\n%s" % [ @path, text ])
          when :crit
            crit("File, %s is not identical\n%s" % [ @path, text ])
          else
            raise ArgumentError, "unknown action %s" % [ opts[:action] ]
          end
        end

      end

      def _diff(original, target, opts = {})

        command = "diff -Nu #{ Shellwords.escape(original) } #{ Shellwords.escape(target) }"

        result = nil
        text = nil
        Open3.popen3(command) do |stdin, stdout, stderr, process|
          status = process.value.exitstatus
          case status
          when 0

            # identical
            result = true
          when 1

            # different
            text = "#{ stdout.read }"
            result = false

          when 2

            # other error
            raise CommandFailed, "command `#{ command }` failed with #{ status }\nstdout: #{ stdout.read }\nstderr: #{ stderr.read }"
          else

            # command not found, etc
            raise CommandFailed, "command `#{ command }` failed with #{ status }\nstdout: #{ stdout.read }\nstderr: #{ stderr.read }"
          end
        end

        return [ result, text ]

      end

    end
  end
end
