# frozen_string_literal: true

require "spec_helper"

module Qansible
  class Check
    describe README do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When README.md is invalid" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          README.new
        end

        describe ".should_not_have_dash_as_heading" do
          it "warns" do
            expect(instance).to receive(:warn)
            instance.should_not_have_dash_as_heading
          end

          it "does not raise_error" do
            expect { instance.should_not_have_dash_as_heading }.not_to raise_error
          end
        end

        describe ".should_not_have_equal_as_heading_two" do
          it "warns" do
            expect(instance).to receive(:warn)
            instance.should_not_have_equal_as_heading_two
          end

          it "does not raise_error" do
            expect { instance.should_not_have_equal_as_heading_two }.not_to raise_error
          end
        end

        describe ".must_have_required_sections" do
          it "raise_error" do
            expect { instance.must_have_required_sections }.to raise_error(SystemExit)
          end
        end

        describe ".should_have_required_sections_at_level_one" do
          it "warns" do
            expect(instance).to receive(:warn)
            instance.should_have_required_sections_at_level_one
          end

          it "does not raise_error" do
            expect { instance.should_have_required_sections_at_level_one }.not_to raise_error
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
