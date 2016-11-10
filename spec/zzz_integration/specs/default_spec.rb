require "spec_helper"
require "open3"

saved = ENV["ANSIBLE_QA_SILENT"]
ENV["ANSIBLE_QA_SILENT"] = nil

describe "ansible-role-qa" do
  let(:command) do
    cmd = "ansible-role-qa.rb -d tmp/ansible-role-default"
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

ENV["ANSIBLE_QA_SILENT"] = saved
