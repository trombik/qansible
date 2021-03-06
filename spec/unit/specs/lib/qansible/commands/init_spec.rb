# frozen_string_literal: true

require "spec_helper"

module Qansible
  class Command
    describe Init do
      let(:c) { Qansible::Command::Init }
      let(:options) { Qansible::Parser::Init.parse(["--directory=tmp", "ansible-role-default"]) }
      let(:i) { Qansible::Command::Init.new(options) }

      context "When valid options given" do
        describe "Qansible::Parser::Init" do
          it "does not raise error" do
            expect { options }.not_to raise_error
          end
        end

        describe "#new" do
          it "does not raise error" do
            expect { i }.not_to raise_error
          end
        end

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
          let(:instance) { Qansible::Command::Init.new(options) }

          it "returns platform_name" do
            expect(instance.platform_name).to eq("freebsd-12.0-amd64")
          end
        end

        describe ".this_year" do
          let(:instance) { Qansible::Command::Init.new(options) }

          it "returns %Y as in strftime" do
            expect(instance.this_year).to eq(Time.new.strftime("%Y"))
          end
        end

        describe ".author" do
          it "returns Qansible::Command::Init::Author" do
            expect(i.author.is_a?(Qansible::Author)).to eq(true)
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

        context "When --quiet is not gievn" do
          before { system "rm -rf tmp; mkdir -p tmp" }
          after { system "rm -rf tmp" }
          describe "#run" do
            it "outputs logs to STDOUT" do
              allow(i).to receive(:silent?).and_return(false)
              expect { i.run }.to output(/INFO/).to_stdout_from_any_process
            end
          end
        end

        context "When --quiet given" do
          let(:options) { Qansible::Parser::Init.parse(["--directory=tmp", "ansible-role-default", "--quiet"]) }

          before { system "rm -rf tmp; mkdir -p tmp" }
          after { system "rm -rf tmp" }
          describe "#run" do
            it "outputs nothing to STDOUT" do
              allow(i).to receive(:silent?).and_return(true)
              expect { i.run }.to output("").to_stdout_from_any_process
            end
          end
        end
      end

      context "When no option given" do
        let(:options) { Qansible::Parser::Init.parse([]) }

        describe "#new" do
          it "does not raise error" do
            expect { i }.not_to raise_error
          end
        end
      end
    end
  end
end
