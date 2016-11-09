require 'spec_helper'

class AnsibleQA
  class Checks
    class Jenkinsfile

      context 'When Jenkinsfile is identical' do

        let(:jenkinsfile) do
          AnsibleQA::Checks::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Checks::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Jenkinsfile.new
        end

        it 'does not warn' do
          expect(jenkinsfile).not_to receive(:warn)
          jenkinsfile.check
        end

      end

      context 'When Jenkinsfile is not identical' do

        let(:jenkinsfile) do
          AnsibleQA::Checks::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          AnsibleQA::Checks::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Jenkinsfile.new
        end

        it 'runs checks and warns' do
          expect(jenkinsfile).to receive(:warn)
          jenkinsfile.check
        end

      end

      context 'When Jenkinsfile does not exist' do

        let(:jenkinsfile) do
          AnsibleQA::Checks::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-empty'))
          AnsibleQA::Checks::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Jenkinsfile.new
        end

        it 'runs checks and exit' do
          expect { jenkinsfile.check }.to raise_error(FileNotFound)
        end

      end

    end
  end
end
