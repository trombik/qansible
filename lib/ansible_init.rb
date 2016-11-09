require "ansible_init/version"
require "ansible_init/author"

require 'pathname'

class InvalidRoleName < StandardError
end

class RoleExist < StandardError
end

class AnsibleInit

  attr_reader :options, :author

  def initialize(opts = {})
    default = {
      :role_name => 'ansible-role-default',
      :box_name => 'trombik/ansible-freebsd-10.3-amd64',
    }
    @options = default.merge(opts)
    validate_role_name(@options[:role_name])
    @author = AnsibleInit::Author.new
  end

  def platform_name
    platform_name = @options[:box_name].split('/').last
    if platform_name.match(/^ansible-/)
      platform_name.gsub!(/^ansible-/, '')
    end
    platform_name
  end

  def this_year
    Time.new.strftime('%Y')
  end

  def validate_role_name(name)
    if ! name.match(/^ansible-role-/)
      raise InvalidRoleName, "role name mus start with `ansible-role`"
    end

    valid_regex = /^[a-zA-Z0-9\-_]+$/
    if ! name.match(valid_regex)
      raise InvalidRoleName, "role name must match %s" % [ valid_regex.to_s ]
    end
    true
  end

  def dest_directory
    Pathname.new(@options[:role_name])
  end

  def templates_directory
    Pathname.new(__FILE__).dirname.join('ansible_init').join('templates')
  end

  def run
    if File.exist?(dest_directory)
      raise RoleExist, "Directory `%s` already exists" % [ dest_directory ]
    end
    Dir.mkdir(dest_directory)
    Dir.chdir(dest_directory) do
      FileUtils.cp_r "#{ templates_directory }/.", '.'
      current_dir = Pathname.pwd
      current_dir.find do |file|
        next if ! file.file?
        content = File.read(file)
        content.gsub!('CHANGEME', options[:role_name].gsub('ansible-role-', ''))
        content.gsub!('YYYY', this_year)
        content.gsub!('DESTNAME', dest_directory.to_s)
        content.gsub!('MYNAME', author.fullname )
        content.gsub!('EMAIL', author.email)
        content.gsub!('PLATFORMNAME', platform_name)
        content.gsub!('BOXNAME', options[:box_name])
        file = File.open(file, 'w')
        file.write(content)
      end

      system "git init ."
      system "git add ."
      system "git commit -m 'initial import'"
      puts "Successfully created `%s`" % [ @options[:role_name] ]
      puts "You need to run bundle install."
    end
  end
end
