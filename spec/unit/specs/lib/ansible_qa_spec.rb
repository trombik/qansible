require "spec_helper"

describe QAnsibleQA do
  describe ".new" do
    it "returns an object" do
      expect { QAnsibleQA.new }.not_to raise_error
      expect(QAnsibleQA.new.is_a?(Object)).to eq(true)
    end
  end
end
