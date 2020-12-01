# frozen_string_literal: true

module Qansible
  class Check
    class GitHubWorkFlowsRubocop < Qansible::Check::Base
      def initialize
        super(path: ".github/workflows/rubocop.yml")
      end

      def check
        must_exist
        must_be_identical
      end
    end
  end
end
