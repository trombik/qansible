require 'pathname'

module AnsibleQA
  module Checks
    class Gemfile < AnsibleQA::Checks::Base

      def initialize
        super('Gemfile')
      end

      def check
        must_exist
        if !should_be_identical
          info "%s should be identical unless you need additional gems" % [ @path ]
          info "Update %s with the latest Gemfile created by ansible-role-init"
        end
      end

    end
  end
end
