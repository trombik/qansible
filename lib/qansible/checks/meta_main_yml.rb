# frozen_string_literal: true

module Qansible
  class Check
    class MetaMainYaml < Qansible::Check::Base
      def initialize
        @yaml = nil
        super(path: "meta/main.yml")
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
        load_yaml unless @yaml
        crit "In `%s`, top level key `galaxy_info` must exist" unless @yaml.key?("galaxy_info")
      end

      def must_have_mandatory_keys_in_galaxy_info
        load_yaml unless @yaml
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
          not_found << k unless @yaml["galaxy_info"].key?(k)
        end
        unless not_found.empty?
          warnings = "In `%s`, these keys must exist\n" % [@path]
          mandatory_keys.each do |k|
            warnings += "%s\n" % [k]
          end
          not_found.sort.each do |k|
            warnings += "Missing key: %s\n" % [k]
          end
          warn warnings
          crit "In `%s`, mandatory keys %s does not exist" % [@path, not_found.join(", ")]
        end
        true
      end

      def should_not_have_default_description
        load_yaml unless @yaml
        default_description = "Configures something"
        warn "In `%s`, description should describe the role, rather than the default. Add description in %s" % [@path, @path] if @yaml["galaxy_info"]["description"] =~ /#{default_description}/
      end

      def must_not_have_categories
        load_yaml unless @yaml
        crit "In `%s`, `galaxy_info` must not have obsolete `categories` as a key. Use `tags` instead" % [@path] if @yaml["galaxy_info"].key?("categories")
      end

      def must_not_have_min_ansible_version_less_than_2_0
        load_yaml unless @yaml
        return if @yaml["galaxy_info"]["min_ansible_version"].to_f >= 2.0

        warn "In `%s`, min_ansible_version is %s\n" % [@path, @yaml["galaxy_info"]["min_ansible_version"]]
        crit "In `%s`, min_ansible_version should be 2.0 or newer" % [@path]
      end

      def must_have_at_least_one_platform_supported
        load_yaml unless @yaml
        crit "In `%s`, `platforms` must have at least one supported platform" % [@path] if @yaml["galaxy_info"]["platforms"].nil?
        crit "In `%s`, `platforms` must have at least one supported platform" % [@path] if @yaml["galaxy_info"]["platforms"].empty?
      end

      def must_have_array_of_galaxy_tags
        load_yaml unless @yaml
        crit "In `%s`, `galaxy_tags` must be an array" % [@path] unless @yaml["galaxy_info"]["galaxy_tags"].is_a?(Array)
      end

      def should_have_at_least_one_tag
        load_yaml unless @yaml
        return unless @yaml["galaxy_info"]["galaxy_tags"].empty?

        warnings = "In `%s`, `galaxy_tags` should have at least one tag. Add a `galaxy_tags`\n" % [@path]
        warnings += "Popular tags can be found at https://galaxy.ansible.com/list"
        warn warnings
      end
    end
  end
end
