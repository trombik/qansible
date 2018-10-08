# frozen_string_literal: true

require "spec_helper"

module Qansible
  class Check
    describe Ackrc do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }
      context "When ackrc is identical" do
        let(:ackrc) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Ackrc.new
        end

        it "responds to check" do
          expect(ackrc.respond_to?("check")).to eq(true)
        end

        it "runs check and does not raise_error" do
          expect { ackrc.check }.not_to raise_error
        end
      end

      context "When ackrc is not identical" do
        let(:ackrc) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-invalid"))
          Ackrc.new
        end

        it "runs check and raise error" do
          expect { ackrc.check }.not_to raise_error
        end

        it "warns" do
          expect(ackrc).to receive(:warn).with(/File, .* is not identical/)
          ackrc.check
        end
      end
    end
  end
end
