class AnsibleQA
  class Check
    class Hier < AnsibleQA::Check::Base

      def initialize
        @required_directories = %w[
          defaults
          extra_modules
          extra_roles
          filter_plugins
          handlers
          library
          meta
          tasks
          templates
          tests
          vars
        ].map { |d| Pathname.new(d) }
        super("")
      end

      def check
        raise_at_end = false
        if ! must_have_all_directories
          raise_at_end = true
        end
        if ! must_have_keepme_in_all_directories
          raise_at_end = true
        end
        if ! must_not_have_test
          raise_at_end = true
        end

        if raise_at_end
          crit "The directory structure does not conform to the hier"
        end
      end

      def must_have_all_directories

        not_found = []
        @required_directories.each do |d|
          if ! File.directory?(@@root + d)
            not_found << d
          end
        end
        if not_found.length > 0
          warn "mkdir %s" % [ not_found.sort.join(" ") ]
          warn "touch %s" % [ not_found.sort.map { |d| d + ".keepme" }.join(" ") ]
        end
        not_found.length == 0

      end

      def must_have_keepme_in_all_directories

        not_found = []
        @required_directories.each do |d|
          keepme = @@root + d + ".keepme"
          if ! File.file?(keepme)
            not_found << keepme
          end
        end
        if not_found.length > 0
          warn "touch %s" % [ not_found.sort.join(" ") ]
        end
        not_found.length == 0

      end

      def must_not_have_test
        if File.directory?(@@root + "test")
          warn "Directory `%s` must not exist" % [ @@root + "test" ]
        end
        not File.directory?(@@root + "test")
      end

    end
  end
end
