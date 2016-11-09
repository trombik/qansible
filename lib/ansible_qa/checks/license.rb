class AnsibleQA
  class Check
    class LICENSE < AnsibleQA::Check::Base

      def initialize
        super('LICENSE')
      end

      def check
        must_exist
      end

    end
  end
end
