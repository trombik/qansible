module Qansible
  class Check
    class Hier < Qansible::Check::Base
      def initialize
        @required_directories = %w[
          defaults
          extra_modules
          filter_plugins
          handlers
          library
          meta
          tasks
          templates
          tests
          vars
        ].map { |d| Pathname.new(d) }
        super
      end

      def check
        raise_at_end = false
        raise_at_end = true unless must_have_all_directories
        raise_at_end = true unless must_have_keepme_in_all_directories
        raise_at_end = true unless must_not_have_test

        crit "The directory structure does not conform to the hier" if raise_at_end
      end

      def must_have_all_directories
        not_found = []
        @required_directories.each do |d|
          not_found << d unless File.directory?(@@root + d)
        end
        unless not_found.empty?
          warn "mkdir %s" % [not_found.sort.join(" ")]
          warn "touch %s" % [not_found.sort.map { |d| d + ".keepme" }.join(" ")]
        end
        not_found.empty?
      end

      def must_have_keepme_in_all_directories
        not_found = []
        @required_directories.each do |d|
          keepme = @@root + d + ".keepme"
          not_found << keepme unless File.file?(keepme)
        end
        warn "touch %s" % [not_found.sort.join(" ")] unless not_found.empty?
        not_found.empty?
      end

      def must_not_have_test
        warn "Directory `%s` must not exist" % [@@root + "test"] if File.directory?(@@root + "test")
        !File.directory?(@@root + "test")
      end
    end
  end
end
