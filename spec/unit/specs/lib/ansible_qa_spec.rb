require "spec_helper"

describe AnsibleQA do

  describe ".new" do
    it "returns an object" do
      expect { AnsibleQA.new }.not_to raise_error
      expect(AnsibleQA.new.is_a?(Object)).to eq(true)
    end
  end

end
