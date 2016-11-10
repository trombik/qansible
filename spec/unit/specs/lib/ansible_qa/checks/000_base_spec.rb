require "spec_helper"

class AnsibleQA
  class Check
    describe Base do
      let(:base) do
        AnsibleQA::Check::Base.tmp("spec/unit/fixtures/ansible-role-latest")
        AnsibleQA::Check::Base.root("spec/unit/fixtures/ansible-role-latest")
        Base.new("foo")
      end

      describe "#new" do
        it "returns an object" do
          expect(base.class).to eq(AnsibleQA::Check::Base)
        end

        it "has zero warning" do
          expect(base.number_of_warnings).to eq(0)
        end

        it "returns path to the file" do
          expect(base.path).to eq(Pathname.new("foo"))
        end
      end

      describe ".colorize" do
        let(:base) { Base.new("foo") }
        it "returns colorized text in red" do
          expect(base.colorize("foo", "red", "black")).to eq "\033[40;31mfoo\033[0m"
        end
      end

      describe ".warn" do
        it "increments number_of_warnings" do
          base.warn("foo")
          base.warn("foo")
          expect(base.number_of_warnings).to eq(2)
        end
      end

      context "when file does not exist" do
        describe ".should_exist" do
          it "warns `should exist`" do
            expect(base).to receive(:warn).with(/File `.*` should exist but not found/)
            base.should_exist
          end
        end
        describe ".must_exist" do
          it "raises FileNotFound" do
            expect { base.must_exist }.to raise_error(FileNotFound, /File `.*` must exist but not found/)
          end
        end
      end

      context "when file is identical" do

        let(:base) do
          AnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          AnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Base.new(".ackrc")
        end

        describe ".should_be_identical" do
          it "does not raise error" do
            expect { base.should_be_identical }.not_to raise_error
          end
        end

        describe ".must_be_identical" do
          it "does not raise error" do
            expect { base.must_be_identical }.not_to raise_error
          end
        end

      end

      context "when file exists" do

        let(:base) do
          AnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          AnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Base.new(".ackrc")
        end

        describe ".must_exist" do
          it "does not raise FileNotFound" do
            expect { base.must_exist }.not_to raise_error
          end
        end

        describe ".should_exist" do
          it "dose not warn" do
            expect(base).not_to receive(:warn)
            base.should_exist
          end
        end

        describe ".read_file" do
          it "reads the file and returns its content as String" do
            expect(base.read_file).to match(/--ignore-dir=vendor\n--ignore-dir=.kitchen/)
            expect(base.read_file.class).to eq(String)
          end
        end

      end

      context "when non-existent YAML file is given" do

        describe ".must_be_yaml" do

          it "raise FileNotFound" do
            expect { base.must_be_yaml }.to raise_error(Errno::ENOENT)
          end
        end
      end

      context "when a valid yaml file is given" do
        describe ".must_be_yaml" do
          let(:base) do
            AnsibleQA::Check::Base.tmp("spec/unit/fixtures/ansible-role-latest/")
            AnsibleQA::Check::Base.root("spec/unit/fixtures/ansible-role-latest/")
            Base.new("tasks/install-FreeBSD.yml")
          end

          it "returns an Array" do
            expect(base.must_be_yaml.class).to eq(Array)
          end
        end
      end

    end
  end
end
