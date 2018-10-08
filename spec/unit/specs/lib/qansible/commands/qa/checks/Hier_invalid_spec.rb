# frozen_string_literal: true

require "spec_helper"

module Qansible
  class Check
    describe Hier do
      context "When `test` directory exists" do
        let(:hier) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest"))
          Hier.new
        end

        describe ".must_not_have_test" do
          it "warns" do
            expect(hier).to receive(:warn)
            hier.must_not_have_test
          end

          it "returns false" do
            expect(hier.must_not_have_test).to eq(false)
          end
        end

        describe ".check" do
          it "exit" do
            expect { hier.check }.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
