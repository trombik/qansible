require "spec_helper"

module Qansible
  class Check
    describe Rakefile do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When Rakefile is identical" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Rakefile.new
        end

        describe ".must_accept_test_as_target" do
          it "does not raise_error" do
            expect { instance.must_accept_test_as_target }.not_to raise_error
          end

          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.must_accept_test_as_target
          end
        end

        describe ".check" do
          it "does not raise_error" do
            expect { instance.check }.not_to raise_error
          end

          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.check
          end
        end
      end
    end
  end
end
