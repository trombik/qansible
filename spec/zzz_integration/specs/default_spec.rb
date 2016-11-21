require "spec_helper"
require "open3"

ENV["PATH"] = ENV["PATH"] + ":" + Pathname.pwd.join("exe").to_s

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

  let(:command) { "qansible init --directory=tmp/ ansible-role-default" }

  it "runs and stderr does not contain anything" do
    _o, e, _s = Open3.capture3(command)
    expect(e).to match(/^$/)
  end

  it "runs and exit status is zero" do
    _o, _e, s = Open3.capture3(command)
    expect(s.success?).to eq(true)
  end

  context "When ansible init finishes" do
    it "creates a git repo" do
      system "#{command} >/dev/null 2>&1"
      Dir.chdir("tmp/ansible-role-default") do
        _o, _e, s = Open3.capture3("git status")
        expect(s.success?).to be true
      end
    end

    it "commits everything" do
      system "#{command} >/dev/null 2>&1"
      Dir.chdir("tmp/ansible-role-default") do
        o, _e, _s = Open3.capture3("git status")
        expect(o).to match(/nothing to commit, working directory clean/)
      end
    end
  end
end

describe "qansible qa" do
  before(:all) do
    system "mkdir tmp"
    system "exe/qansible init --quiet --directory=tmp/ ansible-role-default"
  end

  after(:all) do
    system "rm -rf tmp"
  end

  let(:command) do
    cmd = "exe/qansible qa --directory=tmp/ansible-role-default"
    stdout, stderr, exit_status = Open3.capture3(cmd)
    { :status => exit_status, :stdout => stdout, :stderr => stderr }
  end

  it "target directory exists" do
    expect(File.exist?("tmp/ansible-role-default")).to eq(true)
    expect(File.directory?("tmp/ansible-role-default")).to eq(true)
    expect(File.exist?("tmp/ansible-role-default/.kitchen.local.yml")).to eq(true)
  end

  it "does not raise error" do
    expect { command }.not_to raise_error
  end

  it "exit with zero" do
    expect(command[:status].success?).to eq(true)
  end

  it "stderr does not contain anything" do
    expect(command[:stderr]).to eq("")
  end

  it "contains Number of warnings" do
    pending "investigating"
    expect(command[:stdout]).to match(/Number of warnings/)
  end

  it "warnings equals to 1" do
    pending "investigating"
    expect(command[:stdout]).to match(/Number of warnings: 1/)
  end
end
