module Qansible
  class Check
    class KitchenYml < Qansible::Check::Base
      def initialize
        @yaml = nil
        super(path: ".kitchen.yml")
      end

      def check
        must_exist
        @yaml = must_be_yaml
      end

      def must_have_transport
        @yaml ||= must_be_yaml
        unless @yaml.key?("transport")
          crit "In %s, `transport` must be defined.\nAdd:\ntransport:\n  name: rsync\nto %s." % [ @path, @path ]
        end
      end

      def must_have_transport_name
        @yaml ||= must_be_yaml
        unless @yaml["transport"].key?("name")
          crit "In %s, `transport` must be defined.\nAdd:\ntransport:\n  name: rsync\nto %s." % [ @path, @path ]
        end
      end

      def must_have_transport_name_rsync
        @yaml ||= must_be_yaml
        if !@yaml["transport"]["name"] == "rsync"
          crit "In %s, `transport` must be defined.\nAdd:\ntransport:\n  name: rsync\nto %s." % [ @path, @path ]
        end
      end

      def must_have_provisioner
        @yaml ||= must_be_yaml
        unless @yaml.key?("provisioner")
          crit "In %s, `provisioner` must be defined. Add `provisioner` to %s." % [ @path, @path ]
        end
      end

      def should_have_idempotency_test_enabled
        @yaml ||= must_be_yaml
        if !@yaml["provisioner"].key?("idempotency_test") || !@yaml["provisioner"]["idempotency_test"]
          warnings = "In %s, `idempotency_test` is not set to `true` in `provisioner`. It is strongly recommended to set `idempotency_test` to true\n" % [ @path ]
          warnings += "To make a unit test idempotent, see:\n"
          warnings += "https://github.com/reallyenglish/ansible-role-example/wiki/How_Do_I#how-do-i-run-some-tasks-before-kitchen-coverage\n"
          warn warnings
        end
      end

      def should_have_ansible_vault_password_file
        @yaml ||= must_be_yaml
        if !@yaml["provisioner"].key?("ansible_vault_password_file") || !@yaml["provisioner"]["ansible_vault_password_file"]
          warnings = "In %s, `ansible_vault_password_file` is not set.\n"
          warnings += "Even if ansible-vault is not currently used, you would need it later.\n"
          warnings += "It does not hurt to add it now. Consider to add:\n" % [ @path ]
          warnings += "ansible_vault_password_file: <%%= File.expand_path(ENV['ANSIBLE_VAULT_PASSWORD_FILE'] || '') %%>`\n" % [ @path ]
          warnings += "in %s.\n" % [ @path ]
          warn warnings
        end
      end

      def must_have_platforms
        @yaml ||= must_be_yaml
        if !@yaml.key?("platforms") || !@yaml["platforms"].is_a?(Array) || @yaml["platforms"].empty?
          crit "In %s, `platforms` must be an array and at least one platform must be defined." % [ @path ]
        end
      end

      def should_have_platforms_without_transport
        @yaml ||= must_be_yaml
        @yaml["platforms"].each do |platform|
          name = platform["name"]
          if platform.key?("transport")
            warn "In %s, platform `%s` has `transport` as a key. Consider removing it" % [ @path, name ]
          end
        end
      end

      def must_have_platforms_with_driver
        @yaml ||= must_be_yaml
        @yaml["platforms"].each do |platform|
          name = platform["name"]
          unless platform.key?("driver")
            crit "In %s, platform `%s` does not have `driver` as a key. Add `driver` to %s" % [ @path, name, name ]
          end
        end
      end

      def should_have_platforms_with_driver_box_update_false
        @yaml ||= must_be_yaml
        @yaml["platforms"].each do |platform|
          name = platform["name"]
          if !platform["driver"].key?("box_check_update")
            warn "In %s, platform `%s` does not have `box_update` under `driver` as a key. Add `box_check_update` to `driver`." % [ @path, name ]
          elsif platform["driver"]["box_check_update"] != false
            warn "In %s, platform `%s` does not have `box_check_update` disabled. Disable it by setting it to false." % [ @path, name ]
          end
        end
      end

      def should_not_have_platforms_with_name_start_with_ansible
        @yaml ||= must_be_yaml
        @yaml["platforms"].each do |platform|
          if platform["name"] =~ /^ansible-/
            warn "In %s, platform `%s` has `ansible-` prefix. The prefix is redundant and it just makes typing harder. Consider removing it" % [ @path, platform["name"] ]
          end
        end
      end

      def must_have_array_of_suite
        @yaml ||= must_be_yaml
        if !@yaml.key?("suites") || !@yaml["suites"].is_a?(Array)
          crit "In %s, `suites` must be an array of suite. Add `suites` to the file" % [ @path ]
        end
      end

      def must_have_suites_with_correct_path_to_playbook
        @yaml ||= must_be_yaml
        @yaml["suites"].each do |suite|
          playbook = suite["provisioner"]["playbook"]
          first_element = playbook.to_s.split(File::SEPARATOR).first
          if first_element != "tests"
            crit "In %s, suite `%s` has the path to playbook that does not start with `tests`. Playbooks must be under `tests/serverspec/` Move the file to the directory" % [ @path, suite["name"] ]
          end
        end
      end

      def _parse_box(text)
        text.gsub!(/\/ansible-/, "/") if text.split("/").last =~ /^ansible-/
        (platform, platform_version, arch) = text.split("/").last.split("-")
        user = text.split("/").first
        {
          user: user,
          platform: platform,
          platform_version: platform_version,
          arch: arch
        }
      end
    end
  end
end
