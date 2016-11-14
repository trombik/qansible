require "spec_helper"

module Qansible
  class Command
    describe Base do
      let(:c) { Qansible::Command::Base }
      let(:i) { c.new(nil) }

      describe "::new" do
        it "does not raise error" do
          expect { i }.not_to raise_error
        end

        it "is Qansible::Command" do
          expect(i.class).to be Qansible::Command::Base
        end
      end

      describe "#logger" do
        it "returns Logger" do
          expect(i.logger.is_a?(Logger)).to be true
        end
      end

      describe "#colorize" do
        it "returns colorized text in red" do
          expect(i.colorize("foo", "red", "black")).to eq "\033[40;31mfoo\033[0m"
        end
      end

      context "When silent? is true" do
        describe "#warn" do
          it "logs nothing" do
            allow(i).to receive(:silent?).and_return(true)
            expect { i.warn("foo") }.to output("").to_stdout_from_any_process
          end
        end

        describe "#info" do
          it "logs nothing" do
            allow(i).to receive(:silent?).and_return(true)
            expect { i.info("foo") }.to output("").to_stdout_from_any_process
          end
        end

        describe "#debug" do
          it "logs nothing" do
            allow(i).to receive(:silent?).and_return(true)
            expect { i.debug("foo") }.to output("").to_stdout_from_any_process
          end
        end

        describe "#error" do
          it "logs nothing" do
            allow(i).to receive(:silent?).and_return(true)
            expect { i.error("foo") }.to output("").to_stdout_from_any_process
          end
        end
      end

      context "When not TTY" do
        describe "#warn" do
          it "logs message without color" do
            allow(i).to receive(:tty?).and_return(false)
            allow(i).to receive(:silent?).and_return(false)
            expect { i.warn("foo") }.to output("WARN foo\n").to_stdout_from_any_process
          end
        end
      end
      context "When TTY" do
        describe "#error" do
          it "logs message in red" do
            allow(i).to receive(:tty?).and_return(true)
            allow(i).to receive(:silent?).and_return(false)
            expect { i.error("foo") }.to output("\033[40;31mERROR foo\n\033[0m").to_stdout_from_any_process
          end
        end

        describe "#warn" do
          it "logs message in red" do
            allow(i).to receive(:tty?).and_return(true)
            allow(i).to receive(:silent?).and_return(false)
            expect { i.warn("foo") }.to output("\033[40;31mWARN foo\n\033[0m").to_stdout_from_any_process
          end
        end

        describe "#info" do
          it "logs message in light blue" do
            allow(i).to receive(:tty?).and_return(true)
            allow(i).to receive(:silent?).and_return(false)
            expect { i.info("foo") }.to output("\033[40;1;34mINFO foo\n\033[0m").to_stdout_from_any_process
          end
        end

        describe "#debug" do
          it "logs message in gray" do
            allow(i).to receive(:tty?).and_return(true)
            allow(i).to receive(:silent?).and_return(false)
            expect { i.debug("foo") }.to output("\033[40;37mDEBUG foo\n\033[0m").to_stdout_from_any_process
          end
        end
      end
    end
  end
end
