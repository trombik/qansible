require "spec_helper"

module Qansible
  class Check
    describe Rakefile do
      context "When Rakefile is invalid" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Rakefile.new
        end

        describe ".must_accept_test_as_target" do
          it "raise_error" do
            expect { instance.must_accept_test_as_target }.to raise_error(SystemExit)
          end
        end

        describe ".check" do
          it "raise_error" do
            expect { instance.check }.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
