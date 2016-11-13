require "spec_helper"

module Qansible
  class Check
    describe Hier do
      context "When required directories do not exist" do
        let(:hier) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Hier.new
        end

        describe ".must_have_all_directories" do
          it "warns" do
            expect(hier).to receive(:warn).at_least(:once)
            hier.must_have_all_directories
          end

          it "returns false" do
            expect(hier.must_have_all_directories).to eq(false)
          end
        end

        describe ".must_have_keepme_in_all_directories" do
          it "warns" do
            expect(hier).to receive(:warn).at_least(:once)
            hier.must_have_keepme_in_all_directories
          end

          it "returns false" do
            expect(hier.must_have_keepme_in_all_directories).to eq(false)
          end
        end

        describe ".must_not_have_test" do
          it "does not warn" do
            expect(hier).not_to receive(:warn)
            hier.must_not_have_test
          end

          it "returns true" do
            expect(hier.must_not_have_test).to eq(true)
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
