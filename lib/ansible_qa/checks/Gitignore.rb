class AnsibleQA
  class Checks
    class Gitignore < AnsibleQA::Checks::Base

      def initialize
        super('.gitignore')
      end

      def check
        must_exist

        ignores = [
          '.bundle/',
          'Gemfile.lock',
          '/.kitchen/',
          '.kitchen.local.yml',
          '*.swp',
          'vendor/',
        ]
        found = []
        f  = read_file
        f.each_line do |line|
          ignores.each do |i|
            if line =~ /^#{ Regexp.escape(i) }$/
              found << i
            end
          end
        end
        not_found = ignores - found
        if not_found.length > 0
          warn "In `%s`,  the following items should be ignored: `%s` but not all items are ignored: `%s`" % [ @path, ignores.to_s, not_found.to_s ]
        end

      end

    end
  end
end
