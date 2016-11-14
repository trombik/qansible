require "logger"

module Qansible
  class Command
    class Base

      attr_reader :logger

      def initialize(_options)
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::DEBUG
        @logger.formatter = proc do |severity, _datetime, _progname, msg|
          if silent?
            ""
          elsif tty?
            case severity
            when "WARN", "ERROR", "FATAL", "UNKNOWN"
              colorize("%s %s\n" % [ severity, msg ], "red", "black")
            when "INFO"
              colorize("%s %s\n" % [ severity, msg ], "cyan", "black")
            when "DEBUG"
              colorize("%s %s\n" % [ severity, msg ], "gray", "black")
            end
          else
            "%s %s\n" % [ severity, msg ]
          end
        end
      end

      def silent?
        ENV["QANSIBLE_SILENT"]
      end

      def debug(msg)
        logger.debug(msg)
      end

      def info(msg)
        logger.info(msg)
      end

      def warn(msg)
        logger.warn(msg)
      end

      def error(msg)
        logger.error(msg)
      end

      def tty?
        STDOUT.isatty
      end

      def colorize(text, color = "default", bgcolor = "default")
        return text if ! tty?
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
        raise "colorize: unknown color: %s" % [ color ] if ! colors.key?(color)
        color_code = colors[color]
        raise "colorize: unknown bgcolor: %s" % [ bgcolor ] if ! colors.key?(bgcolor)
        bgcolor_code = bgcolors[bgcolor]
        "\033[#{bgcolor_code};#{color_code}m#{text}\033[0m"
      end
    end
  end
end
