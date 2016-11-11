require "spec_helper"

class QAnsibleQA
  class Check
    describe README do
      context "When README.md is identical" do
        let(:instance) do
          QAnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          QAnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          README.new
        end

        describe ".should_not_have_dash_as_heading" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_not_have_dash_as_heading
          end

          it "does not raise_error" do
            expect { instance.should_not_have_dash_as_heading }.not_to raise_error
          end
        end

        describe ".should_not_have_equal_as_heading_two" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_not_have_equal_as_heading_two
          end

          it "does not raise_error" do
            expect { instance.should_not_have_equal_as_heading_two }.not_to raise_error
          end
        end

        describe ".must_have_required_sections" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.must_have_required_sections
          end

          it "does not raise_error" do
            expect { instance.must_have_required_sections }.not_to raise_error
          end
        end

        describe ".should_have_required_sections_at_level_one" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
            instance.should_have_required_sections_at_level_one
          end

          it "does not raise_error" do
            expect { instance.should_have_required_sections_at_level_one }.not_to raise_error
          end
        end

        describe ".check" do
          it "does not raise_error" do
            expect { instance.check }.not_to raise_error
          end
        end
      end
    end
  end
end
