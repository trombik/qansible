module Qansible
  class Check
    class README < Qansible::Check::Base
      def initialize
        @required_sections = [
          "Requirements",
          "Role Variables",
          "Dependencies",
          "Example Playbook",
          "Author Information"
        ]
        super(path: "README.md")
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
        File.open(@@root + @path, "r") do |f|
          f.each_line do |line|
            line_numbers << f.lineno if line =~ /^--[-]*\s*$/
          end
        end
        unless line_numbers.empty?
          line_numbers.each do |l|
            warn "In %s, at line number %d, `--` is used as heading. use `#` instead" % [ @path, l ]
          end
        end
        !line_numbers.empty?
      end

      def should_not_have_equal_as_heading_two
        line_numbers = []
        File.open(@@root + @path, "r") do |f|
          f.each_line do |line|
            line_numbers << f.lineno if line =~ /^==[=]*\s*$/
          end
        end
        unless line_numbers.empty?
          line_numbers.each do |l|
            warn "In %s, at line number %d, `--` is used as heading. use `#` instead" % [ @path, l ]
          end
        end
        !line_numbers.empty?
      end

      def must_have_required_sections
        found_sections = []
        File.open(@@root + @path, "r") do |f|
          f.each_line do |line|
            found_sections << Regexp.last_match[1] if line =~ /^#\s+(.*)$/
          end
        end
        not_found_sections = @required_sections - found_sections
        unless not_found_sections.empty?
          warnings = "Required sections are:\n"
          @required_sections.sort.each do |s|
            warnings += "%s\n" % [ s ]
          end
          warnings += "Missing sections are:\n"
          not_found_sections.sort.each do |s|
            warnings += "%s\n" % [ s ]
          end
          warn warnings
          crit "In %s, not all required sections were found." % [ @path ]
        end
        !not_found_sections.empty?
      end

      def should_have_required_sections_at_level_one
        warnings = []
        File.open(@@root + @path, "r") do |f|
          f.each_line do |line|
            next unless line =~ /^##+\s+(.*)/
            name = Regexp.last_match[1]
            if @required_sections.include?(name)
              warnings << { lineno: f.lineno, name: name }
            end
          end
        end
        unless warnings.empty?
          warnings.each do |w|
            warn "In %s, at line number %d, required section `%s` is found in second level section. use `# %s` instead." % [ @path, w[:lineno], w[:name], w[:name] ]
          end
        end
        !warnings.empty?
      end
    end
  end
end
