require "spec_helper"

describe AnsibleInit do

  let(:root) { Pathname.new(__FILE__).dirname.parent.parent.parent.parent }

#  it "has a version number" do
#    expect(AnsibleInit::VERSION).not_to be nil
#  end

  describe ".validate_role_name" do

    let(:instance) { AnsibleInit.new }

    it "rejects invalid role names" do
      expect { instance.validate_role_name("role") }.to raise_error(InvalidRoleName)
      expect { instance.validate_role_name("ansible-role-*()?><") }.to raise_error(InvalidRoleName)
    end

    it "accepts `ansible-role-foo_bar`" do
      expect { instance.validate_role_name("ansible-role-foo-bar") }.not_to raise_error
    end
  end

  describe ".new" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "returns an instance" do
      expect { instance }.not_to raise_error
      expect(instance.class).to eq(AnsibleInit)
    end

  end

  describe ".options" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "responds to .options" do
      expect(instance.respond_to?("options")).to eq(true)
    end

    it "returns overrided options" do
      expect(instance.options[:role_name]).to eq("ansible-role-foo")
    end

  end

  describe ".platform_name" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "returns platform_name" do
      expect(instance.platform_name).to eq("freebsd-10.3-amd64")
    end
  end

  describe ".this_year" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "returns %Y as in strftime" do
      expect(instance.this_year).to eq(Time.new.strftime("%Y"))
    end
  end

  describe ".author" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "returns AnsibleInit::Author" do
      expect(instance.author.is_a?(AnsibleInit::Author)).to eq(true)
    end
  end

  describe ".dest_directory" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "returns Pathname" do
      expect(instance.dest_directory.is_a?(Pathname)).to eq(true)
    end
  end

  describe ".templates_directory" do

    let(:instance) { AnsibleInit.new(:role_name => "ansible-role-foo") }

    it "returns templates directory" do
      expect(instance.templates_directory.to_s).to eq(root.join("lib").join("ansible_init").join("templates").to_s)
    end

  end

end
