require 'spec_helper'

class AnsibleQA
  class Checks
    describe CHANGELOG do

      context 'When CHANGELOG.md exists' do

        let(:instance) do
          AnsibleQA::Checks::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          AnsibleQA::Checks::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          CHANGELOG.new
        end

        describe '.check' do
          it 'does not raise_error' do
            expect { instance.check }.not_to raise_error
          end
        end
      end
    end
  end
end
