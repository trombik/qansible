require "spec_helper"

module Qansible
  class Check
    describe CHANGELOG do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }
      context "When CHANGELOG.md exists" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          CHANGELOG.new
        end

        describe ".check" do
          it "does not raise_error" do
            expect { instance.check }.not_to raise_error
          end
        end
      end
    end
  end
end
