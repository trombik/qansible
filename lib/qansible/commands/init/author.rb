require "etc"

module Qansible
  class Command
    class Init
      class Author

        attr_reader :login, :fullname
        def initialize
          @login = Etc.getpwuid(Process.uid).name
          @fullname = Etc.getpwuid(Process.uid).gecos
        end

        def email
          email = `git config --get user.email`
          email.chomp
        end

        alias_method :login_name, :login
        alias_method :whoami, :login

      end
    end
  end
end
