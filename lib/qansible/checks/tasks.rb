# frozen_string_literal: true

module Qansible
  class Check
    class Tasks < Qansible::Check::Base
      def initialize
        @task_files = []
        @task_yaml_content = {}
        super
        _find_all_task_files
        _load_all_tasks_as_yaml
      end

      def check
        should_have_templates_with_validate
        should_have_tasks_with_name
        should_have_tasks_with_capitalized_name
        should_have_tasks_with_verbs
      end

      def should_have_templates_with_validate
        @task_yaml_content.each_key do |file|
          yaml = @task_yaml_content[file]
          next unless yaml

          yaml.each do |task|
            next unless task.key?("template") && !task["template"].key?("validate")

            warnings = "In %s, the following template task does not have validate. Consider validating the file\n" % [file]
            warnings += "%s\n" % [task.to_yaml]
            warn warnings
          end
        end
      end

      def should_have_tasks_with_name
        exceptions = %w[
          assert
          block
          debug
          fail
          include
          include_role
          include_vars
          meta
          set_fact
        ]
        @task_yaml_content.each_key do |file|
          yaml = @task_yaml_content[file]
          next unless yaml

          yaml.each do |task|
            unless task.key?("name")
              if (task.keys & exceptions).any?
                # adding name to these modules has little point
              else
                warnings = "In %s, the following task does not have `name`. Consider adding `name`\n" % [file]
                warnings += "%s\n" % [task.to_yaml]
                warn warnings
              end
            end
          end
        end
      end

      def should_have_tasks_with_capitalized_name
        @task_yaml_content.each_key do |file|
          yaml = @task_yaml_content[file]
          next unless yaml

          yaml.each do |task|
            warn "In %s, task name `%s` does not start with a Capital. Replace the first character with [A-Z]." % [file, task["name"]] if task.key?("name") && task["name"].match(/^[a-z]/)
          end
        end
      end

      def should_have_tasks_with_verbs
        verbs = %w[
          accept add apply archive ask assert bind boot bring build check clean
          clone collect commit configure copy correct create deal delete
          destroy detect disable do download dump dump enable ensure exclude
          execute extract fail fetch find fix flush get handle include
          initialize inject insert install keep list load look make mount
          notify pack patch post put receive reconfigure re-configure register
          reject release remove replace restart restore revert run search see
          select send set shutdown start stop test try umount uninstall unload
          unmount unpack update upload validate verify wait
        ]
        @task_yaml_content.each_key do |file|
          yaml = @task_yaml_content[file]
          next unless yaml

          yaml.each do |task|
            next unless task.key?("name")

            verb = task["name"].split(" ").first.downcase
            if verbs.any? { |v| v == verb }
              # the name starts with one of the verbs
            else
              warnings = "In %s, task name `%s` start with `%s` which is not one of recommended verbs. Consider using one of:\n" % [file, task["name"], verb]
              verbs.sort.each do |v|
                warnings += "%s\n" % [v]
              end
              warnings += "The verb should be present tense and participle."
              warn warnings
            end
          end
        end
      end

      def _find_all_task_files
        tasks_dir = @@root / "tasks"
        @task_files = tasks_dir.children.select { |f| f.file? && f.basename.to_s =~ /\.yml$/ }
      end

      def _load_all_tasks_as_yaml
        @task_files.each do |file|
          yaml = YAML.load_file(file)
          @task_yaml_content[file] = yaml
        end
      end
    end
  end
end
