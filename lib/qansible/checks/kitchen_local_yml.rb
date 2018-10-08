# frozen_string_literal: true

module Qansible
  class Check
    class KitchenLocalYml < Qansible::Check::Base
      def initialize
        super(path: ".kitchen.local.yml")
      end

      def check
        warn "%s is an optional file that overrides .kitchen.yml. It is recommened to create one so that you can use a proxy to make tests faster" % [@path] unless should_exist
      end
    end
  end
end
