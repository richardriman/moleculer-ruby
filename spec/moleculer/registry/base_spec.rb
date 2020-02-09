# frozen_string_literal: true

RSpec.describe Moleculer::Registry::Base do
  subject { Moleculer::Registry::Base.new(broker) }
  let(:broker) { Moleculer::Broker.new(node_id: "test-node") }
  let(:node) { Moleculer::Node.new(broker, id: "remote-node") }
  let(:service_catalog) { subject.instance_variable_get(:@service_catalog) }
  let(:action_catalog) { subject.instance_variable_get(:@action_catalog) }
  let(:event_catalog) { subject.instance_variable_get(:@event_catalog) }
  let(:node_catalog) { subject.instance_variable_get(:@node_catalog) }

  describe "#register_node" do
    it "registers the services with the service catalog" do
      expect(service_catalog).to receive(:register_items_for_node).with(node)
      subject.register_node(node)
    end

    it "registers the nodes actions with the actions catalog" do
      expect(action_catalog).to receive(:register_items_for_node).with(node)
      subject.register_node(node)
    end

    it "registers the nodes events with the actions catalog" do
      expect(event_catalog).to receive(:register_items_for_node).with(node)
      subject.register_node(node)
    end

    it "registers the nodes actions with the actions catalog" do
      expect(node_catalog).to receive(:add).with(node)
      subject.register_node(node)
    end
  end

  describe "#local_node" do
    it "returns the local node" do
      expect(subject.local_node).to eq(node_catalog.local_node)
    end
  end
end
