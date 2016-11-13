require "spec_helper"

module Qansible
  class Check
    describe KitchenLocalYml do
      context "When .kitchen.local.yml does not exist" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          KitchenLocalYml.new
        end

        describe ".check" do
          it "does not raise error" do
            expect { instance.check }.not_to raise_error
          end
        end
        describe ".check" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:twice)
            instance.check
          end
        end
      end
    end
  end
end
