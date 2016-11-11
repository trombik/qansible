class QAnsibleQA
  class Check
    class CHANGELOG < QAnsibleQA::Check::Base

      def initialize
        super(:path => "CHANGELOG.md")
      end

      def check
        must_exist
      end

    end
  end
end
