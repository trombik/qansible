require 'spec_helper'

class AnsibleQA
  class Checks
    class MetaMainYaml

      context 'When .travis.yml does not exist' do
        let(:instance) do
          AnsibleQA::Checks::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-empty/'))
          AnsibleQA::Checks::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest/'))
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

