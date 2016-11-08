require 'spec_helper'

module AnsibleQA
  module Checks
    describe CHANGELOG do

      context 'When CHANGELOG.md does not exist' do

        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-empty/'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          CHANGELOG.new
        end

        describe '.check' do
          it 'raise_error' do
            expect { instance.check }.to raise_error(FileNotFound)
          end
        end
      end
    end
  end
end
