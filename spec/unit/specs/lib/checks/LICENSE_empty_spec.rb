require 'spec_helper'

module AnsibleQA
  module Checks
    class LICENSE
      context "When LICENSE does not exist" do

        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-empty/'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          LICENSE.new
        end

        describe '.check' do
          it 'raise FileNotFound' do
            expect { instance.check }.to raise_error(FileNotFound)
          end
        end

      end
    end
  end
end
