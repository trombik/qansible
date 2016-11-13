require "spec_helper"

module Qansible
  class Check
    describe Hier do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When required directories exist" do
        let(:hier) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Hier.new
        end

        describe ".must_have_all_directories" do
          it "does not warn" do
            expect(hier).not_to receive(:warn)
          end

          it "returns true" do
            expect(hier.must_have_all_directories).to eq(true)
          end
        end

        describe ".must_have_keepme_in_all_directories" do
          it "does not warn" do
            expect(hier).not_to receive(:warn)
            hier.must_have_keepme_in_all_directories
          end

          it "returns true" do
            expect(hier.must_have_keepme_in_all_directories).to eq(true)
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
          it "does not exit" do
            expect { hier.check }.not_to raise_error
          end
        end
      end
    end
  end
end
