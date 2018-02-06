module Qansible
  class Check
    class Jenkinsfile < Qansible::Check::Base
      def initialize
        super(path: "Jenkinsfile")
      end

      def check
        must_exist
        notice "You may ignore warnings if integration test stage is uncommented" unless should_be_identical
      end
    end
  end
end
