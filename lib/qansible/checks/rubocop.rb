module Qansible
  class Check
    class Rubocop < Qansible::Check::Base
      def initialize
        super(path: ".rubocop.yml")
      end

      def check
        must_exist
        must_be_identical
      end
    end
  end
end
