require "pathname"
module Qansible
  class Parser
    class Init
      def self.parse(options)
        args = Qansible::Option::Init.new
        args.directory = Pathname.pwd
        args.verbose = false
        args.box_name = "trombik/ansible-freebsd-10.3-amd64"
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: init [options] ROLENAME"

          opts.on("-v", "--verbose", "Be verbose") do
            args.verbose = true
          end

          opts.on("-d", "--directory=[DIR]", "The directory to create", String) do |d|
            args.directory = Pathname.new(d).expand_path
          end

          opts.on("-h", "--help", "Prints this help") do
            puts opts
            exit
          end
        end
        args.role_name = opt_parser.permute(options).first
        args.role_name = "ansible-role-default" unless args.role_name

        unless args.role_name
          puts opt_parser.to_s
          exit 1
        end
        opt_parser.parse!(options)
        args
      end
    end
  end
end
