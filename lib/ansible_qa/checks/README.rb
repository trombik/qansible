module AnsibleQA
  module Checks
    class README < AnsibleQA::Checks::Base

      def initialize
        @required_sections = [
          'Requirements',
          'Role Variables',
          'Dependencies',
          'Example Playbook',
          'Author Information',
        ]
        super('README.md')
      end

      def check
        must_exist
        should_not_have_dash_as_heading
        should_not_have_equal_as_heading_two
        must_have_required_sections
        should_have_required_sections_at_level_one
      end

      def should_not_have_dash_as_heading
        line_numbers = []
        File.open(@root_dir + @path, 'r') do |f|
          f.each_line do |line|
            if line.match(/^--[-]*\s*$/)
              line_numbers << f.lineno
            end
          end
        end
        if line_numbers.length != 0
          line_numbers.each do |l|
            warn "In %s, at line number %d, `--` is used as heading. use `#` instead" % [ @path, l ]
          end
        end
        line_numbers.length != 0
      end

      def should_not_have_equal_as_heading_two
        line_numbers = []
        File.open(@root_dir + @path, 'r') do |f|
          f.each_line do |line|
            if line.match(/^==[=]*\s*$/)
              line_numbers << f.lineno
            end
          end
        end
        if line_numbers.length != 0
          line_numbers.each do |l|
            warn "In %s, at line number %d, `--` is used as heading. use `#` instead" % [ @path, l ]
          end
        end
        line_numbers.length != 0
      end

      def must_have_required_sections
        found_sections = []
        File.open(@root_dir + @path, 'r') do |f|
          f.each_line do |line|
            if line =~ /^#\s+(.*)$/
              found_sections << Regexp.last_match[1]
            end
          end
        end
        not_found_sections = @required_sections - found_sections
        if not_found_sections.length > 0
          warn "Required sections are:"
          @required_sections.sort.each do |s|
            warn "%s" % [ s ]
          end
          warn "Missing sections are:"
          not_found_sections.sort.each do |s|
            warn "%s" % [ s ]
          end
          crit "In %s, not all required sections were found." % [ @path ]
        end
        not_found_sections.length > 0
      end

      def should_have_required_sections_at_level_one
        warnings = []
        File.open(@root_dir + @path, 'r') do |f|
          f.each_line do |line|
            if line.match(/^##+\s+(.*)/)
              name = Regexp.last_match[1]
              if @required_sections.include?(name)
                warnings << { :lineno => f.lineno, :name => name }
              end
            end
          end
        end
        if warnings.length != 0
          warnings.each do |w|
            warn "In %s, at line number %d, required section `%s` is found in second level section. use `# %s` instead." % [ @path, w[:lineno], w[:name], w[:name]  ]
          end
        end
        warnings.length != 0
      end

    end
  end
end
