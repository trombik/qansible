class AnsibleQA
  class Check
    class CHANGELOG < AnsibleQA::Check::Base

      def initialize
        super("CHANGELOG.md")
      end

      def check
        must_exist
      end

    end
  end
end
