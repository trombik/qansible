require "spec_helper"

module Qansible
  class Parser
    describe Init do
      let(:p) { Qansible::Parser::Init }

      describe "#parse" do
        context "When no options given" do
          let(:opts) { p.parse([]) }

          it "returns verbose with default value, false" do
            expect(opts.verbose).to eq(false)
          end

          it "returns silent with default value, false" do
            expect(opts.silent).to eq(false)
          end

          it "returns directory with default value, `.`" do
            expect(opts.directory).to eq(Pathname.pwd)
          end

          it "returns role_name with default value, ansible-role-default" do
            expect(opts.role_name).to eq("ansible-role-default")
          end

          it "returns box_name with default value, trombik/ansible-freebsd-10.3-amd64" do
            expect(opts.box_name).to eq("trombik/ansible-freebsd-10.3-amd64")
          end
        end

        context "When only verbose given" do
          let(:opts) { p.parse([ "--verbose" ]) }

          it "returns verbose with true" do
            expect(opts.verbose).to eq(true)
          end

          it "returns directory with default value, `.`" do
            expect(opts.directory).to eq(Pathname.pwd)
          end

          it "returns role_name with default value, ansible-role-default" do
            expect(opts.role_name).to eq("ansible-role-default")
          end

          it "returns box_name with default value, trombik/ansible-freebsd-10.3-amd64" do
            expect(opts.box_name).to eq("trombik/ansible-freebsd-10.3-amd64")
          end
        end

        context "When valid options given" do
          let(:valid) { %w(--verbose --directory=foo ansible-role-default) }
          let(:opts) { p.parse(valid) }

          it "does not raise error" do
            expect { p.parse(valid) }.not_to raise_error
          end

          it "returns verbose on" do
            expect(opts.verbose).to be true
          end

          it "returns directory" do
            expect(opts.directory).to eq(Pathname.new("foo").expand_path)
          end

          it "returns role_name" do
            expect(opts.role_name).to eq("ansible-role-default")
          end

          it "returns box_name" do
            expect(opts.box_name).to eq("trombik/ansible-freebsd-10.3-amd64")
          end
        end

        context "When --verbose given" do
          let(:verbose) { %w(--verbose ansible-role-default) }

          it "returns verbose on" do
            opts = p.parse(verbose)
            expect(opts.verbose).to eq true
          end

          it "returns current directory" do
            opts = p.parse(verbose)
            expect(opts.directory).to eq Pathname.pwd
          end
        end

        context "When --directory given" do
          it "returns option with directory" do
            opts = p.parse([ "--directory=path/to/dir", "ansible-role-default" ])
            expect(opts.directory).to eq(Pathname.new("path/to/dir").expand_path)
          end
        end

        context "When role name is the first argument" do
          it "returns correct option" do
            opts = p.parse([ "ansible-role-default", "--directory=path/to/dir"])
            expect(opts.role_name).to eq("ansible-role-default")
          end
        end

        context "When invalid options given" do
          it "exits" do
            pending "TODO"
            expect { p.parse(["--ver"]) }.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
