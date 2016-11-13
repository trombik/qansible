require "spec_helper"

module Qansible
  class Check
    class LICENSE
      context "When LICENSE does not exist" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          LICENSE.new
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
