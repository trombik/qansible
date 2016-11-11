class QAnsible
  class Check
    class CHANGELOG < QAnsible::Check::Base

      def initialize
        super(:path => "CHANGELOG.md")
      end

      def check
        must_exist
      end

    end
  end
end
