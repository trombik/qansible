# frozen_string_literal: true

require "spec_helper"

module Qansible
  class Check
    describe ExtraRoles do
      context "When extra_roles exists" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          ExtraRoles.new
        end

        describe ".should_not_exist" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
            instance.should_not_exist
          end
        end
      end
    end
  end
end
