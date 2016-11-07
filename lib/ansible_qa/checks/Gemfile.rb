require 'pathname'

module AnsibleQA
  module Checks
    class Gemfile < AnsibleQA::Checks::Base

      def initialize
        super('Gemfile')
      end

      def check
        must_exist
        should_be_identical
      end

    end
  end
end
