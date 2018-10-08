# frozen_string_literal: true

module Qansible
  class Check
    class ExtraRoles < Qansible::Check::Base
      def initialize
        super(path: "extra_roles")
      end

      def check
        should_not_exist
      end

      def should_not_exist
        debug "%s Checking `%s`, which must not exist" % [self.class.name, @path]
        result = File.exist?(@@root + @path)
        warn "File or directory `%s` should not exist. Run `rm -rf extra_roles` and remove it from `.kitchen.yml`. See https://github.com/trombik/qansible/issues/51 for why" % [@path] if result
        !result
      end
    end
  end
end
