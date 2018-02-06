require "pathname"

module Qansible
  class Check
    class Gemfile < Qansible::Check::Base
      def initialize
        super(path: "Gemfile")
      end

      def check
        must_exist
        unless should_be_identical
          info "%s should be identical unless you need additional gems" % [ @path ]
          info "Update %s with the latest Gemfile created by `qansible init`" % [ @path ]
        end
      end
    end
  end
end
