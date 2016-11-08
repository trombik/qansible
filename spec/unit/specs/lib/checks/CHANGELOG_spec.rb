require 'spec_helper'

module AnsibleQA
  module Checks
    describe CHANGELOG do

      context 'When CHANGELOG.md exists' do

        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
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
