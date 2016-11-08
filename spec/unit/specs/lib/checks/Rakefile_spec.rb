require 'spec_helper'

module AnsibleQA
  module Checks
    describe Rakefile do

      context 'When Rakefile is identical' do

        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          Rakefile.new
        end

        describe '.must_accept_test_as_target' do
          it 'does not raise_error' do
            expect { instance.must_accept_test_as_target }.not_to raise_error
          end

          it 'does not warn' do
            expect(instance).not_to receive(:warn)
            instance.must_accept_test_as_target
          end
        end

        describe '.check' do
          it 'does not raise_error' do
            expect { instance.check }.not_to raise_error
          end

          it 'does not warn' do
            expect(instance).not_to receive(:warn)
            instance.check
          end
        end
      end
    end
  end
end
