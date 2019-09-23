# frozen_string_literal: true

require_relative "../../../lib/moleculer/transporters/base"
require_relative "subscriber_behavior"

RSpec.describe Moleculer::Broker::Subscriber do
  let(:registry) do
    double(Moleculer::Registry, local_node:      double(Moleculer::Node,
                                                        id:   "test",
                                                        to_h: { services: [], hostname: "" }),
                                remove_node:     true,
                                safe_fetch_node: node)
  end
  let(:transporter) { double(Moleculer::Transporters::Base, subscribe: true) }
  let(:publisher) { double(Moleculer::Broker::Publisher, discover_to_node_id: true) }
  let(:broker) do
    double(Moleculer::Broker,
           config:      Moleculer::Configuration.new,
           transporter: transporter,
           logger:      double(Moleculer::Support::LogProxy, trace: true),
           registry:    registry,
           publisher:   publisher)
  end

  let(:node) { double(Moleculer::Node, beat: true) }

  subject { Moleculer::Broker::Subscriber.new(broker) }

  describe "#subscribe_to_disconnect" do
    it_behaves_like "subscription", "disconnect"

    let(:packet) { double(Moleculer::Packets::Disconnect, sender: "test") }
    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        @subscriber = block
      end
    end

    it "should remove the node from the registry" do
      subject.subscribe_to_disconnect
      @subscriber.call(packet)
      expect(registry).to have_received(:remove_node).with(packet.sender)
    end
  end

  describe "#subscribe_to_heartbeat" do
    it_behaves_like "subscription", "heartbeat"

    let(:packet) { double(Moleculer::Packets::Heartbeat, sender: "test") }
    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        @subscriber = block
      end
      subject.subscribe_to_heartbeat
    end

    it "should fetch the node using safe_fetch_node from the registry" do
      @subscriber.call(packet)
      expect(registry).to have_received(:safe_fetch_node).with(packet.sender)
    end

    context "when a node is present" do
      let(:node) { double(Moleculer::Node, beat: true) }

      before :each do
        allow(registry).to receive(:safe_fetch_node).with("test").and_return(node)
      end

      it "should send a beat to the registered node" do
        @subscriber.call(packet)
        expect(node).to have_received(:beat)
      end
    end

    context "when a node is not present" do
      before :each do
        allow(registry).to receive(:safe_fetch_node).with("test").and_return(nil)
      end

      it "should publish a discover packet to the node" do
        @subscriber.call(packet)
        expect(publisher).to have_received(:discover_to_node_id).with("test")
      end
    end
  end
end
