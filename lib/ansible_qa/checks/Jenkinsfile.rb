class AnsibleQA
  class Checks
    class Jenkinsfile < AnsibleQA::Checks::Base

      def initialize
        super('Jenkinsfile')
      end

      def check
        must_exist
        if ! should_be_identical
          notice 'You may ignore warnings if integration test stage is uncommented'
        end
      end

    end
  end
end
