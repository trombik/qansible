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
          "Gemfile.lock",
          "/.kitchen/",
          ".kitchen.local.yml",
          "*.swp",
          "vendor/"
        ]
        found = []
        f = read_file
        f.each_line do |line|
          ignores.each do |i|
            found << i if line =~ /^#{ Regexp.escape(i) }$/
          end
        end
        not_found = ignores - found
        unless not_found.empty?
          warn "In `%s`,  the following items should be ignored: `%s` but not all items are ignored: `%s`" % [ @path, ignores.to_s, not_found.to_s ]
        end
      end
    end
  end
end
