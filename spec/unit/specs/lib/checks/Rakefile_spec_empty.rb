require 'spec_helper'

module AnsibleQA
  module Checks
    describe Rakefile do

      context 'When Rakefile does not exist' do

        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-empty/'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          Rakefile.new
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
