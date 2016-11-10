class AnsibleQA
  class Check
    class LICENSE < AnsibleQA::Check::Base

      def initialize
        super(:path => "LICENSE")
      end

      def check
        must_exist
      end

    end
  end
end
