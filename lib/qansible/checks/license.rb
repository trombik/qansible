class QAnsible
  class Check
    class LICENSE < QAnsible::Check::Base

      def initialize
        super(:path => "LICENSE")
      end

      def check
        must_exist
      end

    end
  end
end
