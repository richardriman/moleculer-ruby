# frozen_string_literal: true

RSpec.describe Moleculer::Registry::Base do
  let(:broker) { double(Moleculer::Registry::Base, get_logger: true) }
  let(:node) { double(Moleculer::Node, id: "test") }

  subject { Moleculer::Registry::Base.new(broker) }

  describe "#register_node" do
    it "adds the node to the node list" do
      subject.register_node(node)
      expect(subject.instance_variable_get(:@nodes)[node.id]).to eq(node)
    end
  end

  describe "#node?" do
    it "returns true if the node exists" do
      subject.register_node(node)
      expect(subject.node?(node)).to be_truthy
    end

    it "returns false if the node does not exist" do
      expect(subject.node?(node)).to be_falsey
    end
  end
end
