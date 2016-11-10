require "spec_helper"

class AnsibleQA
  class Check
    describe Hier do
      context "When `test` directory exists" do
        let(:hier) do
          AnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid"))
          AnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Hier.new
        end

        describe ".must_not_have_test" do
          it "warns" do
            expect(hier).to receive(:warn)
            hier.must_not_have_test
          end

          it "returns false" do
            expect(hier.must_not_have_test).to eq(false)
          end
        end

        describe ".check" do
          it "exit" do
            expect { hier.check }.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
