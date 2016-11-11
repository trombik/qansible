require "spec_helper"

class Qansible
  class Command
    class Init
      describe Parser do
        let(:p) { Qansible::Command::Init::Parser }

        describe "#parse" do
          context "When valid options given" do
            let(:valid) { %w(--verbose --directory=foo ansible-role-default) }

            it "does not raise error" do
              expect { p.parse(valid) }.not_to raise_error
            end

            it "returns all options" do
              opts = p.parse(valid)
              expect(opts.verbose).to be true
              expect(opts.directory).to eq(Pathname.new("foo").expand_path)
              expect(opts.role_name).to eq("ansible-role-default")
            end
          end

          context "When --verbose given" do
            let(:verbose) { %w(--verbose ansible-role-default) }

            it "returns verbose on but other options are nil" do
              opts = p.parse(verbose)
              expect(opts.verbose).to eq true
              expect(opts.directory).to eq nil
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
end
