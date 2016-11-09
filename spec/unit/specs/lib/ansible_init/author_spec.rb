require 'spec_helper'
require 'etc'

class AnsibleInit
  describe Author do
    let(:instance) { AnsibleInit::Author.new }
    let(:whoami) { Etc.getpwuid(Process.uid).name }
    let(:gecos) { Etc.getpwuid(Process.uid).gecos }

    describe "#new" do
      it "returns an Object" do
        expect(instance.is_a?(Object)).to eq(true)
      end
    end

    describe ".whoami" do
      it 'returns user name' do
        expect(instance.whoami).to eq(whoami)
      end
    end

    describe ".login_name" do
      it 'returns user name' do
        expect(instance.login_name).to eq(whoami)
      end
    end

    describe '.fullname' do
      it 'returns full name' do
        expect(instance.fullname).to eq(gecos)
      end
    end

    describe '.email' do
      it 'returns email address' do
        expect(instance).to receive(:`).with('git config --get user.email').and_return('foo@example.com')
        expect(instance.email).to eq('foo@example.com')
      end
    end

  end
end
