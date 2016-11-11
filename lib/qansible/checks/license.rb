class Qansible
  class Check
    class LICENSE < Qansible::Check::Base

      def initialize
        super(:path => "LICENSE")
      end

      def check
        must_exist
      end

    end
  end
end
