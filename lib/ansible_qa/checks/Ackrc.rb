class AnsibleQA
  class Checks
    class Ackrc < AnsibleQA::Checks::Base

      def initialize
        super('.ackrc')
      end

      def check
        must_exist
        should_be_identical
      end

    end
  end
end
