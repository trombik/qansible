require "spec_helper"

module Qansible
  class Command
    describe QA do
      let(:c) { Qansible::Command::QA }
      let(:i) { Qansible::Command::QA.new(options) }
      let(:options) do
        o = Qansible::Option::QA.new
        o.directory = Pathname.new("spec/unit/fixture/ansible-role-latest")
        o
      end

      describe "#new" do
        it "does not raise error" do
          expect { c.new(options) }.not_to raise_error
        end
      end

      describe ".all_check_classes" do
        it "returns array of QAnsibleQA::Check" do
          expect(i.all_check_classes).to include(Qansible::Check::README)
        end
      end

      describe ".create_reference_tree" do
        it "creates reference tree under /tmp/foo" do
          command = "ansible-role-init %s" % [ Shellwords.escape(options.role_name) ]
          response = Open3.popen3("echo")
          allow(Open3).to receive(:popen3).with(command).and_yield(*response)
          allow(Dir).to receive(:chdir)
          expect { i.create_reference_tree(Pathname.new("/tmp/foo")) }.not_to raise_error
        end
      end
    end
  end
end
