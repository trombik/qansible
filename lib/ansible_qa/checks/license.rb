class AnsibleQA
  class Checks
    class LICENSE < AnsibleQA::Checks::Base

      def initialize
        super('LICENSE')
      end

      def check
        must_exist
      end

    end
  end
end
