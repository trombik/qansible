require "pathname"
require "optparse"

module Qansible
  class Parser
    class QA
      def self.parse(options)
        args = Qansible::Option::QA.new
        args.directory = current_dir
        args.role_name = args.directory.basename.to_s
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: qa [DIR] [options]"

          opts.on("-v", "--verbose", "Be verbose") do
            args.verbose = true
          end

          opts.on("-d", "--directory=[DIR]", "The role directory") do |d|
            args.directory = Pathname.new(d).expand_path
            args.role_name = args.directory.basename
          end

          opts.on("-h", "--help", "Prints this help") do
            puts opts
            exit
          end
        end
        opt_parser.parse!(options)
        args.directory = Pathname.pwd.expand_path unless args.directory
        args
      end

      def self.current_dir
        Pathname.pwd
      end
    end
  end
end
