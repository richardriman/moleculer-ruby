# frozen_string_literal: true

RSpec.describe Moleculer::Registry::NodeCatalog do
  describe "::new" do
    let(:broker) { Moleculer::Broker.new }
    let(:registry) { Moleculer::Registry::Base.new(broker) }

    subject { Moleculer::Registry::NodeCatalog.new(registry) }

    it "creates a new local node" do
      expect(subject.local_node).to be_a(Moleculer::Node)
    end

    it "updates sets the new local node to the correct information" do
      expect(subject.local_node.id).to eq(broker.node_id)
      expect(subject.local_node.local).to eq(true)
      expect(subject.local_node.ip_list).to_not be_empty
      expect(subject.local_node.seq).to eq(1)
      expect(subject.local_node.client).to include(
        type:         "ruby",
        version:      Moleculer::VERSION,
        lang_version: RUBY_VERSION,
      )
    end

    it "adds the local node to the node list" do
      expect(subject.nodes["test"] == subject.local_node.id)
    end
  end
end
