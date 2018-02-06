module Qansible
  class Check
    class CHANGELOG < Qansible::Check::Base
      def initialize
        super(path: "CHANGELOG.md")
      end

      def check
        must_exist
      end
    end
  end
end
