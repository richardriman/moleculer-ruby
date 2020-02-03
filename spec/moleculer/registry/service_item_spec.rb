# frozen_string_literal: true

require_relative "../../../lib/moleculer/registry/service_item"

RSpec.describe Moleculer::Registry::ServiceItem do
  let(:node) { double(Moleculer::Registry::Node, id: "test-node") }
  subject { Moleculer::Registry::ServiceItem.new(node, "test", "1", {}, {}, true) }

  describe "#equals?" do
    it "returns true when the information matches" do
      expect(subject.equals?("test", "1", node.id)).to be_truthy
    end

    it "returns false when the information doesn't match" do
      expect(subject.equals?("test", "1", "wrong")).to_not be_truthy
      expect(subject.equals?("test-wrong", "1", "test-node")).to_not be_truthy
      expect(subject.equals?( "test", "2", "test-node")).to_not be_truthy
    end
  end
end
