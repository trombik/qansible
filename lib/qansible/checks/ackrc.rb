module Qansible
  class Check
    class Ackrc < Qansible::Check::Base

      def initialize
        super(:path => ".ackrc")
      end

      def check
        must_exist
        should_be_identical
      end

    end
  end
end
