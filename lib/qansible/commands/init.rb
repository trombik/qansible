# frozen_string_literal: true

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
        platform_name.gsub!(/^ansible-/, "") if platform_name =~ /^ansible-/
        platform_name
      end

      attr_reader :author

      def validate_role_name(name)
        raise InvalidRoleName, "No role name given" unless name
        raise InvalidRoleName, "Invalid role name `%s` given. Role name mus start with `ansible-role`" % [name] unless name =~ /^ansible-role-/

        valid_regex = /^[a-zA-Z0-9\-_]+$/
        raise InvalidRoleName, "Invalid role name `%s` given. role name must match %s" % [name, valid_regex.to_s] unless name.match(valid_regex)

        true
      end

      def dest_directory
        Pathname.new(@options.directory).join(@options.role_name)
      end

      def templates_directory
        Pathname.new(__FILE__).dirname.join("init").join("templates")
      end

      def run
        raise RoleExist, "Directory `%s` already exists" % [dest_directory] if File.exist?(dest_directory)

        Dir.mkdir(dest_directory)
        Dir.chdir(dest_directory) do
          FileUtils.cp_r "#{templates_directory}/.", "."
          FileUtils.cp_r "#{templates_directory}/.github", "."
          FileUtils.mv "gitignore", ".gitignore"
          FileUtils.mv "rubocop.yml", ".rubocop.yml"
          Pathname.pwd.find do |file|
            next unless file.file?

            content = File.read(file)
            content.gsub!("CHANGEME", @options.role_name.gsub("ansible-role-", ""))
            content.gsub!("YYYY", this_year)
            content.gsub!("DESTNAME", @options.role_name)
            content.gsub!("MYNAME", @author.fullname)
            content.gsub!("EMAIL", @author.email)
            content.gsub!("PLATFORMNAME", platform_name)
            content.gsub!("BOXNAME", @options.box_name)
            file = File.open(file, "w")
            file.write(content)
            file.close
          end

          git_options = nil
          git_options = "--quiet" if silent?
          system "git init #{git_options} ."
          system "git add ."
          system "git commit -m 'initial import' #{git_options}"
        end
        show_advice
      end

      def show_advice
        info "Successfully created `%s`" % [@options.role_name]
        info "You need to run bundle install."
      end
    end
  end
end
