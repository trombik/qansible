class AnsibleQA
  class Check
    class Travis < AnsibleQA::Check::Base

      def initialize
        super(".travis.yml")
      end

      def check
        must_exist
        must_be_identical
      end

    end
  end
end
