require 'spec_helper'

class AnsibleQA
  class Check
    context 'When Gemfile is identical' do
      describe Gemfile do
        let(:gemfile) do
          AnsibleQA::Check::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Check::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Gemfile.new
        end

        it 'responds to check' do
          expect(gemfile.respond_to?('check')).to eq(true)
        end

        it 'runs check and does not raise error' do
          expect { gemfile.check }.not_to raise_error
        end

      end
    end

    context 'When Gemfile is not identical' do
      describe Gemfile do
        let(:gemfile) do
          AnsibleQA::Check::Base.root(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          AnsibleQA::Check::Base.tmp(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Gemfile.new
        end

        it 'warns' do
          expect(gemfile).to receive(:warn).with(/File, .* is not identical/)
          gemfile.check
        end
      end
    end
  end
end
