# frozen_string_literal: true

module Qansible
  class Check
    class Gitignore < Qansible::Check::Base
      def initialize
        super(path: ".gitignore")
      end

      def check
        must_exist

        ignores = [
          ".bundle/",
          "/.kitchen/",
          ".kitchen.local.yml",
          "*.swp",
          "vendor/"
        ]
        found = []
        f = read_file
        f.each_line do |line|
          ignores.each do |i|
            found << i if line =~ /^#{Regexp.escape(i)}$/
          end
        end
        not_found = ignores - found
        warn "In `%s`,  the following items should be ignored: `%s` but not all items are ignored: `%s`" % [@path, ignores.to_s, not_found.to_s] unless not_found.empty?
      end
    end
  end
end
