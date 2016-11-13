require "spec_helper"

module Qansible
  class Command
    class QA
      describe Parser do
        let(:p) { Qansible::Command::QA::Parser }

        describe "#parse" do
          context "When valid options given" do
            let(:valid) { %w(--verbose --directory=/etc) }

            it "does not raise error" do
              expect { p.parse(valid) }.not_to raise_error
            end

            it "returns option object" do
              expect(p.parse(valid).class).to eq(Qansible::Command::QA::Options)
            end

            it "returns correct values" do
              opts = p.parse(valid)
              expect(opts.directory).to eq(Pathname.new("/etc"))
              expect(opts.verbose).to eq(true)
            end
          end

          context "When invalid options given" do
            let(:invalid) { %w(--foo-bar) }

            it "raise OptionParser::InvalidOption" do
              expect { p.parse(invalid) }.to raise_error(OptionParser::InvalidOption)
            end
          end
        end
      end
    end
  end
end
