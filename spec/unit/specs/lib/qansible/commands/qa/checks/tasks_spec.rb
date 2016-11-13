require "spec_helper"

module Qansible
  class Check
    describe Tasks do
      before(:all) { create_latest_tree }
      after(:all) { remove_latest_tree }

      context "When task files are valid" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Tasks.new
        end

        describe ".should_have_templates_with_validate" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_have_templates_with_validate
          end

          it "does not raise_error" do
            expect { instance.should_have_templates_with_validate }.not_to raise_error
          end
        end

        describe ".should_have_tasks_with_name" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_have_tasks_with_name
          end

          it "does not raise_error" do
            expect { instance.should_have_tasks_with_name }.not_to raise_error
          end
        end

        describe ".should_have_tasks_with_capitalized_name" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_have_tasks_with_capitalized_name
          end

          it "does not raise_error" do
            expect { instance.should_have_tasks_with_capitalized_name }.not_to raise_error
          end
        end

        describe ".should_have_tasks_with_verbs" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_have_tasks_with_verbs
          end

          it "does not raise_error" do
            expect { instance.should_have_tasks_with_verbs }.not_to raise_error
          end
        end

        describe ".check" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.check
          end

          it "does not raise_error" do
            expect { instance.check }.not_to raise_error
          end
        end
      end
    end
  end
end
