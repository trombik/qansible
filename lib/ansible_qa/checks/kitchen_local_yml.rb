module AnsibleQA
  module Checks
    class KitchenLocalYml < AnsibleQA::Checks::Base

      def initialize
        super('.kitchen.local.yml')
      end

      def check

        if ! should_exist
          warn "%s is an optional file that overrides .kitchen.yml. It is recommened to create one so that you can use a proxy to make tests faster" % [ @path ]
        end

      end

    end
  end
end
