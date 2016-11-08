require 'spec_helper'

module AnsibleQA
  module Checks
    class Travis

      context 'When .travis.yml is identical' do
        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Travis.new
        end

        describe '.check' do
          it 'does not warn' do
            puts instance.methods.sort.to_yaml
            expect(instance).not_to receive(:warn)
            instance.check
          end
        end
        describe '.check' do
          it 'exits without error' do
            expect { instance.check }.not_to raise_error
          end
        end
      end

      context 'When .travis.yml is not identical' do
        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Travis.new
        end

        describe '.check' do
          it 'raises critical error' do
            expect { instance.check }.to raise_error(SystemExit)
          end
        end
      end

      context 'When .travis.yml does not exist' do
        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-empty'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Travis.new
        end

        describe '.check' do
          it 'raises critical error' do
            expect { instance.check }.to raise_error(FileNotFound)
          end
        end
      end

    end
  end
end
