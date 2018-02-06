module Qansible
  class Check
    class IssueTemplate < Qansible::Check::Base
      def initialize
        super(path: Pathname.new(".github/ISSUE_TEMPLATE.md"))
      end

      def check
        must_exist
      end
    end
  end
end
