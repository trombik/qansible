require "open3"
require "yaml"

class FileNotFound < StandardError
end

class CommandFailed < StandardError
end

module Qansible
  class Check
    class Base
      @@root = nil
      @@tmp = nil
      @@verbose = false

      def self.root(arg = nil)
        if arg
          @@root = arg.is_a?(Pathname) ? arg : Pathname.new(arg)
        end
        @@root
      end

      def self.tmp(arg = nil)
        if arg
          @@tmp = arg.is_a?(Pathname) ? arg : Pathname.new(arg)
        end
        @@tmp
      end

      def self.verbose(arg = nil)
        @@verbose = arg unless arg.nil?
        @@verbose
      end

      attr_reader :self, :number_of_warnings, :path

      def initialize(opts = {})
        raise ArgumentError, "BUG: child class passed `%s`, instead of Hash" % [opts.class] unless opts.is_a?(Hash)
        valid_options = [
          :path
        ]
        opts.each_key do |k|
          raise ArgumentError, "BUG: child class passed invalid option %s" % [k] unless valid_options.include?(k)
        end
        @number_of_warnings = 0
        @path = opts[:path].is_a?(Pathname) ? opts[:path] : Pathname.new(opts[:path]) if opts[:path]
      end

      def must_exist
        debug "%s Checking file `%s`, which must exist" % [self.class.name, @path]
        result = File.exist?(@@root + @path)
        raise FileNotFound, "File `%s` must exist but not found" % [@@root + @path] unless result
      end

      def should_exist
        debug "%s Checking file `%s`, which should exist" % [self.class.name, @path]
        result = File.exist?(@@root + @path)
        warn "File `%s` should exist but not found" % [@path] unless result
        result
      end

      def must_be_yaml
        debug "%s Checking file `%s`, which should be a valid YAML" % [self.class.name, @path]
        hash = {}
        begin
          hash = YAML.load_file(@@root.join(@path.to_s))
        rescue StandardError => e
          raise e
        end
        hash
      end

      def read_file
        debug "%s Loading file `%s` for read" % [self.class.name, @path]
        File.read(@@root.join(@path).to_s)
      end

      def is_tty?
        STDOUT.isatty
      end

      def debug(msg)
        msg = "[debug] %s" % msg
        msg = colorize(msg, "gray", "black")
        STDOUT.puts(msg) if @@verbose && !ENV["QANSIBLE_SILENT"]
      end

      def info(msg)
        msg = "[info] %s" % msg
        msg = colorize(msg, "cyan", "black")
        STDOUT.puts(msg) unless ENV["QANSIBLE_SILENT"]
      end

      def notice(msg)
        msg = "[notice] %s" % msg
        msg = colorize(msg, "green", "black")
        STDOUT.puts(msg) unless ENV["QANSIBLE_SILENT"]
      end

      def warn(msg)
        msg = "[warn] %s" % msg
        msg = colorize(msg, "yellow", "black")
        STDOUT.puts(msg) unless ENV["QANSIBLE_SILENT"]
        @number_of_warnings += 1
      end

      def crit(text)
        msg = "[crit] %s" % [text]
        msg = colorize(msg, "light red", "black")
        Kernel.warn(msg) unless ENV["QANSIBLE_SILENT"]
        exit 1
      end

      def colorize(text, color = "default", bgcolor = "default")
        return text unless is_tty?
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
        raise "colorize: unknown color: %s" % [color] unless colors.key?(color)
        color_code = colors[color]
        raise "colorize: unknown bgcolor: %s" % [bgcolor] unless colors.key?(bgcolor)
        bgcolor_code = bgcolors[bgcolor]
        "\033[#{bgcolor_code};#{color_code}m#{text}\033[0m"
      end

      def should_be_identical
        debug "%s Checking file `%s`, which should be identical" % [self.class.name, @path]
        check_is_identical(action: :warn)
      end

      def must_be_identical
        debug "%s Checking file `%s`, which must be identical" % [self.class.name, @path]
        check_is_identical(action: :crit)
      end

      def check_is_identical(opts = {})
        default = {
          action: :warn,
          diff_option: "-Nu"
        }
        opts = default.merge(opts)

        original = @@tmp + @path
        target = @@root + @path
        (is_same, text) = _diff(original, target)

        unless is_same
          case opts[:action]
          when :warn
            warn("File, %s is not identical\n%s" % [@path, text])
          when :crit
            crit("File, %s is not identical\n%s" % [@path, text])
          else
            raise ArgumentError, "unknown action %s" % [opts[:action]]
          end
        end
        is_same
      end

      def _diff(original, target, _opts = {})
        command = "diff -Nu #{Shellwords.escape(original)} #{Shellwords.escape(target)}"

        result = nil
        text = nil
        Open3.popen3(command) do |_stdin, stdout, stderr, process|
          status = process.value.exitstatus
          case status
          when 0

            # identical
            result = true
          when 1

            # different
            text = stdout.read.to_s
            result = false

          when 2

            # other error
            raise CommandFailed, "command `#{command}` failed with #{status}\nstdout: #{stdout.read}\nstderr: #{stderr.read}"
          else

            # command not found, etc
            raise CommandFailed, "command `#{command}` failed with #{status}\nstdout: #{stdout.read}\nstderr: #{stderr.read}"
          end
        end

        [result, text]
      end
    end
  end
end
