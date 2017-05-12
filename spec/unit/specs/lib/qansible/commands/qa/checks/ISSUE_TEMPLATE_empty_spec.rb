require "spec_helper"

module Qansible
  class Check
    class IssueTemplate
      context "When ISSUE_TEMPLATE.md does not exist" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          IssueTemplate.new
        end

        describe ".check" do
          it "raise FileNotFound" do
            expect { instance.check }.to raise_error(FileNotFound)
          end
        end
      end
    end
  end
end
