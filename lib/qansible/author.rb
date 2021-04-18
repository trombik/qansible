# frozen_string_literal: true

require "etc"

module Qansible
  class Author
    def initialize; end

    def email
      email = `git config --get user.email`
      email.chomp
    end

    def fullname
      fullname = `git config --get user.name`
      fullname.chomp
    end
  end
end
