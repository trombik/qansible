require "shellwords"
require "fileutils"

class RoleExist < StandardError
end

class InvalidRoleName < StandardError
end

module Qansible
  class Command
    class Init < Qansible::Command::Base

      def initialize(options)
        super
        @options = options
        @author = Qansible::Author.new 
        ENV["QANSIBLE_SILENT"] = "y" if @options.silent
      end

      def this_year
        Time.new.strftime("%Y")
      end

      def platform_name
        platform_name = @options.box_name.split("/").last
        if platform_name.match(/^ansible-/)
          platform_name.gsub!(/^ansible-/, "")
        end
        platform_name
      end

      def author
        @author
      end

      def validate_role_name(name)
        if ! name
          raise InvalidRoleName, "No role name given"
        end
        if ! name.match(/^ansible-role-/)
          raise InvalidRoleName, "Invalid role name `%s` given. Role name mus start with `ansible-role`" % [ name ]
        end

        valid_regex = /^[a-zA-Z0-9\-_]+$/
        if ! name.match(valid_regex)
          raise InvalidRoleName, "Invalid role name `%s` given. role name must match %s" % [ name, valid_regex.to_s ]
        end
        true
      end

      def dest_directory
        Pathname.new(@options.directory).join(@options.role_name)
      end

      def templates_directory
        Pathname.new(__FILE__).dirname.join("init").join("templates")
      end

      def run
        if File.exist?(dest_directory)
          raise RoleExist, "Directory `%s` already exists" % [ dest_directory ]
        end
        Dir.mkdir(dest_directory)
        Dir.chdir(dest_directory) do
          FileUtils.cp_r "#{ templates_directory }/.", "."
          FileUtils.mv "gitignore", ".gitignore"
          Pathname.pwd.find do |file|
            next if ! file.file?
            content = File.read(file)
            content.gsub!("CHANGEME", @options.role_name.gsub("ansible-role-", ""))
            content.gsub!("YYYY", this_year)
            content.gsub!("DESTNAME", @options.role_name)
            content.gsub!("MYNAME", @author.fullname )
            content.gsub!("EMAIL", @author.email)
            content.gsub!("PLATFORMNAME", platform_name)
            content.gsub!("BOXNAME", @options.box_name)
            file = File.open(file, "w")
            file.write(content)
            file.close
          end

          git_options = nil
          if silent?
            git_options = "--quiet"
          end
          system "git init #{git_options} ."
          system "git add ."
          system "git commit -m 'initial import' #{git_options}"
        end
        show_advice
      end

      def show_advice
        info "Successfully created `%s`" % [ @options.role_name ]
        info "You need to run bundle install."
      end
    end
  end
end
