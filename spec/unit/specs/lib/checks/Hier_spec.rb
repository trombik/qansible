require 'spec_helper'

module AnsibleQA
  module Checks
    describe Hier do

      context 'When required directories do not exist' do

        let(:hier) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-empty'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Hier.new
        end

        describe '.must_have_all_directories' do
          it 'warns' do
            expect(hier).to receive(:warn).at_least(:once)
            hier.must_have_all_directories
          end

          it 'returns false' do
            expect(hier.must_have_all_directories).to eq(false)
          end
        end

        describe '.must_have_keepme_in_all_directories' do
          it 'warns' do
            expect(hier).to receive(:warn).at_least(:once)
            hier.must_have_keepme_in_all_directories
          end

          it 'returns false' do
            expect(hier.must_have_keepme_in_all_directories).to eq(false)
          end
        end

        describe '.must_not_have_test' do
          it 'does not warn' do
            expect(hier).not_to receive(:warn)
            hier.must_not_have_test
          end

          it 'returns true' do
            expect(hier.must_not_have_test).to eq(true)
          end
        end

        describe '.check' do
          it 'exit' do
            expect { hier.check }.to raise_error(SystemExit)
          end
        end
      end

      context 'When required directories exist' do

        let(:hier) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Hier.new
        end

        describe '.must_have_all_directories' do
          it 'does not warn' do
            expect(hier).not_to receive(:warn)
          end

          it 'returns true' do
            expect(hier.must_have_all_directories).to eq(true)
          end
        end

        describe '.must_have_keepme_in_all_directories' do
          it 'does not warn' do
            expect(hier).not_to receive(:warn)
            hier.must_have_keepme_in_all_directories
          end

          it 'returns true' do
            expect(hier.must_have_keepme_in_all_directories).to eq(true)
          end
        end

        describe '.must_not_have_test' do
          it 'does not warn' do
            expect(hier).not_to receive(:warn)
            hier.must_not_have_test
          end

          it 'returns true' do
            expect(hier.must_not_have_test).to eq(true)
          end
        end

        describe '.check' do
          it 'does not exit' do
            expect { hier.check }.not_to raise_error
          end
        end
      end

      context 'When `test` directory exists' do

        let(:hier) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Hier.new
        end

        describe '.must_not_have_test' do
          it 'warns' do
            expect(hier).to receive(:warn)
            hier.must_not_have_test
          end

          it 'returns false' do
            expect(hier.must_not_have_test).to eq(false)
          end
        end

        describe '.check' do
          it 'exit' do
            expect { hier.check }.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
