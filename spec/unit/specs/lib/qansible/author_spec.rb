# frozen_string_literal: true

require "spec_helper"
require "etc"

module Qansible
  describe Author do
    let(:instance) { Qansible::Author.new }

    describe "#new" do
      it "returns an Object" do
        expect(instance.is_a?(Object)).to eq(true)
      end
    end

    describe ".fullname" do
      it "returns full name" do
        expect(instance).to receive(:`).with("git config --get user.name").and_return("Foo Bar")
        expect(instance.fullname).to eq("Foo Bar")
      end
    end

    describe ".email" do
      it "returns email address" do
        expect(instance).to receive(:`).with("git config --get user.email").and_return("foo@example.com")
        expect(instance.email).to eq("foo@example.com")
      end
    end
  end
end
