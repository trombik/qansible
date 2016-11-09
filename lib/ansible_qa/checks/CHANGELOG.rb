class AnsibleQA
  class Checks
    class CHANGELOG < AnsibleQA::Checks::Base

      def initialize
        super('CHANGELOG.md')
      end

      def check
        must_exist
      end

    end
  end
end
