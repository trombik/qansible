require "spec_helper"
require "open3"

saved = ENV["QANSIBLE_SILENT"]
ENV["QANSIBLE_SILENT"] = nil

describe "qansible init" do
  before(:all) do
    system "mkdir -p tmp"
  end

  after(:all) do
    system "rm -rf tmp"
  end
  after(:each) do
    system "rm -rf tmp/ansible-role-default"
  end

  let(:command) { "exe/qansible init --directory=tmp/ ansible-role-default" }

  it "runs and stderr does not contain anything" do
    _o, e, _s = Open3.capture3(command)
    expect(e).to match(/^$/)
  end

  it "runs and exit status is zero" do
    _o, _e, s = Open3.capture3(command)
    expect(s.success?).to eq(true)
  end
end

describe "ansible-role-qa" do
  before(:all) do
    system "mkdir tmp"
    system "qansible init --directory=tmp/ ansible-role-default"
  end

  after(:all) do
    system "rm -rf tmp"
  end

  let(:command) do
    cmd = "qansible qa --directory=tmp/ansible-role-default"
    stdout, stderr, exit_status = Open3.capture3(cmd)
    { :status => exit_status, :stdout => stdout, :stderr => stderr }
  end

  it "target directory exists" do
    expect(File.exist?("tmp/ansible-role-default")).to eq(true)
    expect(File.directory?("tmp/ansible-role-default")).to eq(true)
  end

  it "does not raise error" do
    expect { command }.not_to raise_error
    expect(File.exist?("tmp/ansible-role-default/.kitchen.local.yml")).to eq(true)
  end

  it "exit with zero" do
    expect(command[:status].success?).to eq(true)
  end

  it "stderr does not contain anything" do
    expect(command[:stderr]).to match(/^$/)
  end

  it "contains Number of warnings" do
    expect(command[:stdout]).to match(/Number of warnings/)
  end

  it "warnings equals to zero" do
    expect(command[:stdout]).to match(/Number of warnings: 1/)
  end
end

ENV["QANSIBLE_SILENT"] = saved
