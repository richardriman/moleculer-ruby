# frozen_string_literal: true

RSpec.describe Moleculer::Registry::NodeCatalog do
  describe "::new" do
    let(:broker) { double(Moleculer::Broker::Base, node_id: "test") }
    let(:registry) { double(Moleculer::Registry::Base, broker: broker, logger: true) }

    subject { Moleculer::Registry::NodeCatalog.new(registry) }

    it "creates a new local node" do
      expect(subject.local_node).to be_a(Moleculer::Registry::Node)
    end

    it "updates sets the new local node to the correct information" do
      expect(subject.local_node.id).to eq("test")
    end
  end
end
