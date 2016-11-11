class QAnsible
  class Check
    class MetaMainYaml < QAnsible::Check::Base

      def initialize
        @yaml = nil
        super(:path => "meta/main.yml")
      end

      def check
        must_exist
        must_be_yaml
        must_have_galaxy_info
        must_have_mandatory_keys_in_galaxy_info
        should_not_have_default_description
        must_not_have_categories
        must_not_have_min_ansible_version_less_than_2_0
        must_have_at_least_one_platform_supported
        must_have_array_of_galaxy_tags
        should_have_at_least_one_tag
      end

      def load_yaml
        @yaml = must_be_yaml
      end

      def must_have_galaxy_info
        load_yaml if not @yaml
        if ! @yaml.has_key?("galaxy_info")
          crit "In `%s`, top level key `galaxy_info` must exist"
        end
      end

      def must_have_mandatory_keys_in_galaxy_info
        load_yaml if not @yaml
        mandatory_keys = %w[
          author
          company
          description
          galaxy_tags
          license
          min_ansible_version
          platforms
        ]
        not_found = []
        mandatory_keys.each do |k|
          if ! @yaml["galaxy_info"].has_key?(k)
            not_found << k
          end
        end
        if not_found.length != 0
          warn "In `%s`, these keys must exist" % [ @path ]
          mandatory_keys.each do |k|
            warn "%s" % [ k ]
          end
          not_found.sort.each do |k|
            warn "Missing key: %s" % [ k ]
          end
          crit "In `%s`, mandatory keys %s does not exist" % [ @path, not_found.join(", ") ]
        end
        true
      end

      def should_not_have_default_description
        load_yaml if not @yaml
        default_description = "Configures something"
        if @yaml["galaxy_info"]["description"].match(/#{ default_description }/)
          warn "In `%s`, description should describe the role, rather than the default. Add description in %s" % [ @path, @path ]
        end
      end

      def must_not_have_categories
        load_yaml if not @yaml
        if @yaml["galaxy_info"].has_key?("categories")
          crit "In `%s`, `galaxy_info` must not have obsolete `categories` as a key. Use `tags` instead" % [ @path ]
        end
      end

      def must_not_have_min_ansible_version_less_than_2_0
        load_yaml if not @yaml
        if @yaml["galaxy_info"]["min_ansible_version"].to_f < 2.0
          warn "In `%s`, min_ansible_version is %s" % [ @path, @yaml["galaxy_info"]["min_ansible_version"] ]
          crit "In `%s`, min_ansible_version should be 2.0 or newer" % [ @path ]
        end
      end

      def must_have_at_least_one_platform_supported
        load_yaml if not @yaml
        if @yaml["galaxy_info"]["platforms"].nil?
          crit "In `%s`, `platforms` must have at least one supported platform" % [ @path ]
        end
        if @yaml["galaxy_info"]["platforms"].length < 1
          crit "In `%s`, `platforms` must have at least one supported platform" % [ @path ]
        end
      end

      def must_have_array_of_galaxy_tags
        load_yaml if not @yaml
        if ! @yaml["galaxy_info"]["galaxy_tags"].is_a?(Array)
          crit "In `%s`, `galaxy_tags` must be an array" % [ @path ]
        end
      end

      def should_have_at_least_one_tag
        load_yaml if not @yaml
        if @yaml["galaxy_info"]["galaxy_tags"].length < 1
          warn "In `%s`, `galaxy_tags` should have at least one tag. Add a `galaxy_tags`" % [ @path ]
          warn "Popular tags can be found at https://galaxy.ansible.com/list"
        end
      end

    end
  end
end
