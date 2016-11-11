require "spec_helper"

class QAnsibleQA
  class Check
    class LICENSE
      context "When LICENSE does not exist" do
        let(:instance) do
          QAnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty/"))
          QAnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
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
