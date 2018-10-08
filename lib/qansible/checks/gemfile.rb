# frozen_string_literal: true

require "pathname"

module Qansible
  class Check
    class Gemfile < Qansible::Check::Base
      def initialize
        super(path: "Gemfile")
      end

      def check
        must_exist
        return unless should_be_identical

        msg = "%s should be identical unless you need additional gems. "\
          "Update %s with the latest Gemfile created by `qansible init`" % [@path, @path]
        info msg
      end
    end
  end
end
