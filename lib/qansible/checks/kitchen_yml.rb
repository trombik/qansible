class Qansible
  class Check
    class KitchenYml < Qansible::Check::Base

      def initialize
        @yaml = nil
        super(:path => ".kitchen.yml")
      end

      def check
        must_exist
        @yaml = must_be_yaml
      end

      def must_have_transport
        @yaml = must_be_yaml if ! @yaml
        if ! @yaml.has_key?("transport")
          crit "In %s, `transport` must be defined.\nAdd:\ntransport:\n  name: rsync\nto %s." % [ @path, @path ]
        end
      end

      def must_have_transport_name
        @yaml = must_be_yaml if ! @yaml
        if ! @yaml["transport"].has_key?("name")
          crit "In %s, `transport` must be defined.\nAdd:\ntransport:\n  name: rsync\nto %s." % [ @path, @path ]
        end
      end

      def must_have_transport_name_rsync
        @yaml = must_be_yaml if ! @yaml
        if ! @yaml["transport"]["name"] == "rsync"
          crit "In %s, `transport` must be defined.\nAdd:\ntransport:\n  name: rsync\nto %s." % [ @path, @path ]
        end
      end

      def must_have_provisioner
        @yaml = must_be_yaml if !@yaml
        if ! @yaml.has_key?("provisioner")
          crit "In %s, `provisioner` must be defined. Add `provisioner` to %s." % [ @path, @path ]
        end
      end

      def should_have_idempotency_test_enabled
        @yaml = must_be_yaml if !@yaml
        if ! @yaml["provisioner"].has_key?("idempotency_test") || ! @yaml["provisioner"]["idempotency_test"]
          warn "In %s, `idempotency_test` is not set to `true` in `provisioner`. It is strongly recommended to set `idempotency_test` to true" % [ @path ]
          warn "To make a unit test idempotent, see:"
          warn "https://github.com/reallyenglish/ansible-role-example/wiki/How_Do_I#how-do-i-run-some-tasks-before-kitchen-coverage"
        end
      end

      def should_have_ansible_vault_password_file
        @yaml = must_be_yaml if !@yaml
        if ! @yaml["provisioner"].has_key?("ansible_vault_password_file") || ! @yaml["provisioner"]["ansible_vault_password_file"]
          warn "In %s, `ansible_vault_password_file` is not set. Even if ansible-vault is not currently used, you would need it later. It does not hurt to add it now. Consider to add:" % [ @path ]
          warn "ansible_vault_password_file: <%%= File.expand_path(ENV['ANSIBLE_VAULT_PASSWORD_FILE'] || '') %%>`" % [ @path ]
          warn "in %s." % [ @path ]
        end
      end

      def must_have_platforms
        @yaml = must_be_yaml if !@yaml
        if ! @yaml.has_key?("platforms") || ! @yaml["platforms"].is_a?(Array) || @yaml["platforms"].length == 0
          crit "In %s, `platforms` must be an array and at least one platform must be defined." % [ @path ]
        end
      end

      def should_have_platforms_without_transport
        @yaml = must_be_yaml if !@yaml
        @yaml["platforms"].each do |platform|
          name = platform["name"]
          if platform.has_key?("transport")
            warn "In %s, platform `%s` has `transport` as a key. Consider removing it" % [ @path, name ]
          end
        end
      end

      def must_have_platforms_with_driver
        @yaml = must_be_yaml if !@yaml
        @yaml["platforms"].each do |platform|
          name = platform["name"]
          if ! platform.has_key?("driver")
            crit "In %s, platform `%s` does not have `driver` as a key. Add `driver` to %s" % [ @path, name, name ]
          end
        end
      end

      def should_have_platforms_with_driver_box_update_false
        @yaml = must_be_yaml if !@yaml
        @yaml["platforms"].each do |platform|
          name = platform["name"]
          if ! platform["driver"].has_key?("box_check_update")
            warn "In %s, platform `%s` does not have `box_update` under `driver` as a key. Add `box_check_update` to `driver`." % [ @path, name ]
          elsif platform["driver"]["box_check_update"] != false
            warn "In %s, platform `%s` does not have `box_check_update` disabled. Disable it by setting it to false." % [ @path, name ]
          end
        end
      end

      def should_not_have_platforms_with_name_start_with_ansible
        @yaml = must_be_yaml if !@yaml
        @yaml["platforms"].each do |platform|
          if platform["name"].match(/^ansible-/)
            warn "In %s, platform `%s` has `ansible-` prefix. The prefix is redundant and it just makes typing harder. Consider removing it" % [ @path, platform["name"] ]
          end
        end
      end

      def must_have_array_of_suite
        @yaml = must_be_yaml if !@yaml
        if ! @yaml.has_key?("suites") || ! @yaml["suites"].is_a?(Array)
          crit "In %s, `suites` must be an array of suite. Add `suites` to the file" % [ @path ]
        end
      end

      def must_have_suites_with_correct_path_to_playbook
        @yaml = must_be_yaml if !@yaml
        @yaml["suites"].each do |suite|
          playbook = suite["provisioner"]["playbook"]
          first_element = playbook.to_s.split(File::SEPARATOR).first
          if first_element != "tests"
            crit "In %s, suite `%s` has the path to playbook that does not start with `tests`. Playbooks must be under `tests/serverspec/` Move the file to the directory" % [ @path, suite["name"] ]
          end
        end
      end

      def _parse_box(text)
        if text.split("/").last.match(/^ansible-/)
          text.gsub!(/\/ansible-/, "/")
        end
        (platform, platform_version, arch) = text.split("/").last.split("-")
        user = text.split("/").first
        {
          :user => user,
          :platform => platform,
          :platform_version => platform_version,
          :arch => arch,
        }
      end

    end
  end
end
