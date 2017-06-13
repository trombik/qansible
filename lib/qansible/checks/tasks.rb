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
        @task_yaml_content.keys.each do |file|
          yaml = @task_yaml_content[file]
          next unless yaml
          yaml.each do |task|
            if task.has_key?("template") && ! task["template"].has_key?("validate")
              warnings = "In %s, the following template task does not have validate. Consider validating the file\n" % [ file ]
              warnings += "%s\n" % [ task.to_yaml ]
              warn warnings
            end
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
        @task_yaml_content.keys.each do |file|
          yaml = @task_yaml_content[file]
          next unless yaml
          yaml.each do |task|
            if ! task.has_key?("name")
              if (task.keys & exceptions).any?
                # adding name to these modules has little point
              else
                warnings = "In %s, the following task does not have `name`. Consider adding `name`\n" % [ file ]
                warnings += "%s\n" % [ task.to_yaml ]
                warn warnings
              end
            end
          end
        end
      end

      def should_have_tasks_with_capitalized_name
        @task_yaml_content.keys.each do |file|
          yaml = @task_yaml_content[file]
          next unless yaml
          yaml.each do |task|
            if task.has_key?("name") && task["name"].match(/^[a-z]/)
              warn "In %s, task name `%s` does not start with a Capital. Replace the first character with [A-Z]." % [ file, task["name"] ]
            end
          end
        end
      end

      def should_have_tasks_with_verbs
        verbs = %w[
          add apply bring check configure copy create delete destroy disable do
          download enable ensure fail fetch find include install load make
          mount re-configure reconfigure register remove replace restart run
          see set shutdown start stop test umount uninstall unload update
          validate accept wait mount fail assert validate insert detect inject
          patch flush clean dump restore wait look search revert uninstall
          accept reject put get upload download exclude list fix
        ]
        @task_yaml_content.keys.each do |file|
          yaml = @task_yaml_content[file]
          next unless yaml
          yaml.each do |task|
            if task.has_key?("name")
              verb = task["name"].split(" ").first.downcase
              if verbs.any? { |v| v == verb }
                # the name starts with one of the verbs
              else
                warnings = "In %s, task name `%s` start with `%s` which is not one of recommended verbs. Consider using one of:\n" % [ file, task["name"], verb ]
                verbs.sort.each do |v|
                  warnings += "%s\n" % [ v ]
                end
                warnings += "The verb should be present tense and participle."
                warn warnings
              end
            end
          end
        end
      end

      def _find_all_task_files
        tasks_dir = @@root + "tasks"
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
