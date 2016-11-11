require "spec_helper"

class QAnsibleQA
  class Check
    describe Tasks do
      context "When task files are not valid" do
        let(:instance) do
          QAnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid/"))
          QAnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Tasks.new
        end

        describe ".should_have_templates_with_validate" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
            instance.should_have_templates_with_validate
          end

          it "does not raise_error" do
            expect { instance.should_have_templates_with_validate }.not_to raise_error
          end
        end

        describe ".should_have_tasks_with_name" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
            instance.should_have_tasks_with_name
          end

          it "does not raise_error" do
            expect { instance.should_have_tasks_with_name }.not_to raise_error
          end
        end

        describe ".should_have_tasks_with_capitalized_name" do
          it "warns" do
            expect(instance).to receive(:warn)
            instance.should_have_tasks_with_capitalized_name
          end

          it "does not raise_error" do
            expect { instance.should_have_tasks_with_capitalized_name }.not_to raise_error
          end
        end

        describe ".should_have_tasks_with_verbs" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
            instance.should_have_tasks_with_verbs
          end

          it "does not raise_error" do
            expect { instance.should_have_tasks_with_verbs }.not_to raise_error
          end
        end

        describe ".check" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
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
