require 'spec_helper'

module AnsibleQA
  module Checks
    class MetaMainYaml

      context 'When .travis.yml does not exist' do
        let(:instance) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-empty/'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
          MetaMainYaml.new
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

