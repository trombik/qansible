# frozen_string_literal: true

module Qansible
  class Check
    class Yamllint < Qansible::Check::Base
      def initialize
        super(path: ".yamllint.yml")
      end

      def check
        must_exist
      end
    end
  end
end
