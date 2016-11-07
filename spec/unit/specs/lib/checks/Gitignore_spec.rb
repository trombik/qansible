require 'spec_helper'

module AnsibleQA
  module Checks
    class Gitignore

      context 'When gitignore lacks mandatory entries' do

        let(:gitignore) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Gitignore.new
        end

        it 'responds to check' do
          expect(gitignore.respond_to?('check')).to eq(true)
        end

        it 'runs checks and warns' do
          expect(gitignore).to receive(:warn).with(/the following items should be ignored:/)
          gitignore.check
        end

      end

      context 'When gitignore is identical' do

        let(:gitignore) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Gitignore.new
        end

        it 'runs checks and does not warn' do
          expect(gitignore).not_to receive(:warn)
          gitignore.check
        end

      end

    end
  end
end
