class AnsibleQA
  class Check
    class Jenkinsfile < AnsibleQA::Check::Base

      def initialize
        super(:path => "Jenkinsfile")
      end

      def check
        must_exist
        if ! should_be_identical
          notice "You may ignore warnings if integration test stage is uncommented"
        end
      end

    end
  end
end
