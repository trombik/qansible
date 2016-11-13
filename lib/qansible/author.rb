require "etc"

module Qansible
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

    alias login_name login
    alias whoami login

  end
end
