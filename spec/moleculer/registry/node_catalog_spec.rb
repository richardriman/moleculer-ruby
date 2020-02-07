# frozen_string_literal: true

RSpec.describe Moleculer::Registry::NodeCatalog do
  let(:broker) { Moleculer::Broker.new(node_id: "test") }
  let(:registry) { Moleculer::Registry::Base.new(broker) }

  subject { Moleculer::Registry::NodeCatalog.new(registry) }

  describe "::new" do
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
      expect(subject.instance_variable_get(:@nodes)[subject.local_node.id]).to eq(subject.local_node)
    end
  end

  describe "#add" do
    let(:node) { Moleculer::Node.new(broker, id: "other-node") }

    before :each do
      allow(registry).to receive(:register_services_for_node)
    end

    it "adds a node to the catalog" do
      subject.add(node)
      expect(subject.instance_variable_get(:@nodes)["other-node"]).to eq(node)
    end

    context "when a new node" do
      it "calls @registry.register_services_for_node with is_update set as false" do
        subject.add(node)
        expect(registry).to have_received(:register_services_for_node).with(node, nil)
      end
    end

    context "when an existing node" do
      it "calls @registry.register_services_for_node with is_update set as false" do
        subject.add(node)
        subject.add(node)
        expect(registry).to have_received(:register_services_for_node).with(node, true)
      end
    end
  end

end
