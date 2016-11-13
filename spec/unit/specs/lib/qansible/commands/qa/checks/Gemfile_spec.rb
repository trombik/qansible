require "spec_helper"

module Qansible
  class Check
    describe Gemfile do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When Gemfile is identical" do
        let(:gemfile) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Gemfile.new
        end

        it "responds to check" do
          expect(gemfile.respond_to?("check")).to eq(true)
        end

        it "runs check and does not raise error" do
          expect { gemfile.check }.not_to raise_error
        end
      end

      context "When Gemfile is not identical" do
        let(:gemfile) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Gemfile.new
        end

        it "warns" do
          expect(gemfile).to receive(:warn).with(/File, .* is not identical/)
          gemfile.check
        end
      end
    end
  end
end
