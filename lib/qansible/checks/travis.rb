class Qansible
  class Check
    class Travis < Qansible::Check::Base

      def initialize
        super(:path => ".travis.yml")
      end

      def check
        must_exist
        must_be_identical
      end

    end
  end
end
