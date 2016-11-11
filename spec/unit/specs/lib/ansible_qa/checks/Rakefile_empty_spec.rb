require "spec_helper"

class QAnsibleQA
  class Check
    describe Rakefile do
      context "When Rakefile does not exist" do
        let(:instance) do
          QAnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-empty/"))
          QAnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          Rakefile.new
        end

        describe ".check" do
          it "raise_error" do
            expect { instance.check }.to raise_error(FileNotFound)
          end
        end
      end
    end
  end
end
