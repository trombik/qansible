require "spec_helper"

module Qansible
  class Check
    describe Base do
      before(:all) do
        create_latest_tree
      end

      after(:all) do
        remove_latest_tree
      end

      context "When invalid yaml given" do
        describe ".must_be_yaml" do
          let(:base) do
            Qansible::Check::Base.root("spec/unit/fixtures/ansible-role-invalid/")
            Qansible::Check::Base.tmp("spec/unit/fixtures/ansible-role-invalid/")
            Base.new(path: "invalid.yml")
          end

          it "raises Psych::SyntaxError" do
            expect { base.must_be_yaml }.to raise_error(Psych::SyntaxError)
          end
        end
      end

      context "When file is not identical" do
        let(:base) do
          Qansible::Check::Base.root("spec/unit/fixtures/ansible-role-invalid/")
          Qansible::Check::Base.tmp("spec/unit/fixtures/ansible-role-latest/")
          Base.new(path: ".ackrc")
        end

        describe ".should_be_identical" do
          it "does not raise error" do
            expect(base).to receive(:warn)
            expect { base.should_be_identical }.not_to raise_error
          end
        end

        describe ".must_be_identical" do
          it "raises error" do
            expect { base.must_be_identical }.to raise_error(SystemExit)
          end
        end
      end

      context "When file does not exist" do
        let(:base) do
          Qansible::Check::Base.root("spec/unit/fixtures/ansible-role-invalid/")
          Qansible::Check::Base.tmp("spec/unit/fixtures/ansible-role-latest/")
          Base.new(path: "no_such_file")
        end

        describe ".read_file" do
          it "raises an exception" do
            expect { base.read_file }.to raise_error(Errno::ENOENT)
          end
        end
      end
    end
  end
end
