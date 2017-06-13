require "spec_helper"

module Qansible
  class Check
    describe ExtraRoles do
      context "When extra_roles does not exist" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          ExtraRoles.new
        end

        describe ".should_not_exist" do
          it "does not warns" do
            expect(instance).not_to receive(:warn)
            instance.should_not_exist
          end
        end
      end
    end
  end
end
