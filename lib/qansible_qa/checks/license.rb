class QAnsibleQA
  class Check
    class LICENSE < QAnsibleQA::Check::Base

      def initialize
        super(:path => "LICENSE")
      end

      def check
        must_exist
      end

    end
  end
end
