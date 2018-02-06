require "spec_helper"

module Qansible
  class Parser
    describe QA do
      let(:p) { Qansible::Parser::QA }

      describe "#parse" do
        context "When valid options given" do
          let(:valid) { %w[--verbose --directory=/ansible-role-foo] }

          it "does not raise error" do
            expect { p.parse(valid) }.not_to raise_error
          end

          it "returns option object" do
            expect(p.parse(valid).class).to eq(Qansible::Option::QA)
          end

          it "returns correct values" do
            opts = p.parse(valid)
            expect(opts.directory).to eq(Pathname.new("/ansible-role-foo"))
            expect(opts.verbose).to eq(true)
          end
        end

        context "When no options given" do
          let(:no_potions) { [] }

          it "returns current directory" do
            allow(p).to receive(:current_dir).and_return(Pathname.new("/path/to/ansible-role-foo"))
            opts = p.parse(no_potions)
            expect(opts.directory).to eq(Pathname.new("/path/to/ansible-role-foo"))
          end

          it "returns role_name = ansible-role-foo" do
            allow(p).to receive(:current_dir).and_return(Pathname.new("/path/to/ansible-role-foo"))
            opts = p.parse(no_potions)
            expect(opts.role_name).to eq("ansible-role-foo")
          end
        end

        context "When invalid options given" do
          let(:invalid) { %w[--foo-bar] }

          it "raise OptionParser::InvalidOption" do
            expect { p.parse(invalid) }.to
            raise_error(OptionParser::InvalidOption)
          end
        end
      end
    end
  end
end
