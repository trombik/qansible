# frozen_string_literal: true

module Qansible
  class Check
    class RubocopTodo < Qansible::Check::Base
      def initialize
        super(path: ".rubocop_todo.yml")
      end

      def check
        must_exist
      end
    end
  end
end
