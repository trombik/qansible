require "spec_helper"

class Qansible
  class Command
    describe Init do
      let(:c) { Qansible::Command::Init }
      let(:options) { Qansible::Command::Init::Parser.parse( [ "--directory=foo", "ansible-role-default" ]) }
      let(:i) { Qansible::Command::Init.new(options) }

      context "When valid options given" do
        describe "Qansible::Command::Init::Parser" do
          it "does not raise error" do
            expect { options }
          end
        end

        describe "#new" do
          it "does not raise error" do
            expect { i }.not_to raise_error
          end
        end

        describe ".validate_role_name" do
          it "rejects empty role name" do
            expect { i.validate_role_name("") }.to raise_error(InvalidRoleName)
          end

          it "rejects invalid role name (no leading ansible-role-)" do
            expect { i.validate_role_name("role") }.to raise_error(InvalidRoleName)
          end

          it "rejects invalid role name (invalid characters)" do
            expect { i.validate_role_name("ansible-role-*()?><") }.to raise_error(InvalidRoleName)
          end

          it "accepts `ansible-role-foo_bar`" do
            expect { i.validate_role_name("ansible-role-foo-bar") }.not_to raise_error
            expect(i.validate_role_name("ansible-role-foo-bar")).to eq(true)
          end

          describe ".platform_name" do
            let(:instance) { QAnsibleInit.new(:role_name => "ansible-role-foo") }

            it "returns platform_name" do
              expect(instance.platform_name).to eq("freebsd-10.3-amd64")
            end
          end

          describe ".this_year" do
            let(:instance) { QAnsibleInit.new(:role_name => "ansible-role-foo") }

            it "returns %Y as in strftime" do
              expect(instance.this_year).to eq(Time.new.strftime("%Y"))
            end
          end

          describe ".author" do
            it "returns QAnsibleInit::Author" do
              expect(i.author.is_a?(Qansible::Init::Author)).to eq(true)
            end
          end

          describe ".dest_directory" do
            it "returns Pathname" do
              expect(i.dest_directory.is_a?(Pathname)).to eq(true)
            end
          end

          describe ".templates_directory" do
            it "returns templates directory" do
              expect(i.templates_directory.to_s).to eq(Pathname.new("lib/qansible/commands/init/templates").expand_path.to_s)
            end
          end

        end
      end
    end
  end
end
