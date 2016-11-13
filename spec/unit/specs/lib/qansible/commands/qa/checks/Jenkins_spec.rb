require "spec_helper"

module Qansible
  class Check
    describe Jenkinsfile do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When Jenkinsfile is identical" do
        let(:jenkinsfile) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Jenkinsfile.new
        end

        it "does not warn" do
          expect(jenkinsfile).not_to receive(:warn)
          jenkinsfile.check
        end
      end

      context "When Jenkinsfile is not identical" do
        let(:jenkinsfile) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Jenkinsfile.new
        end

        it "runs checks and warns" do
          expect(jenkinsfile).to receive(:warn)
          jenkinsfile.check
        end
      end

      context "When Jenkinsfile does not exist" do
        let(:jenkinsfile) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Jenkinsfile.new
        end

        it "runs checks and exit" do
          expect { jenkinsfile.check }.to raise_error(FileNotFound)
        end
      end
    end
  end
end
