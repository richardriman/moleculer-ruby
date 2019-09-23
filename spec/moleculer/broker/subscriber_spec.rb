# frozen_string_literal: true

require_relative "../../../lib/moleculer/transporters/base"
require_relative "subscriber_behavior"
require_relative "subscriber_helper"

RSpec.describe Moleculer::Broker::Subscriber do
  let(:registry) do
    double(Moleculer::Registry, local_node:      double(Moleculer::Node,
                                                        id:   "local",
                                                        to_h: { services: [], hostname: "" }),
                                remove_node:     true,
                                safe_fetch_node: node)
  end
  let(:transporter) { double(Moleculer::Transporters::Base, subscribe: true) }
  let(:publisher) { double(Moleculer::Broker::Publisher, discover_to_node_id: true, info: true) }
  let(:broker) do
    double(Moleculer::Broker,
           config:          Moleculer::Configuration.new,
           transporter:     transporter,
           logger:          double(Moleculer::Support::LogProxy, trace: true),
           registry:        registry,
           publisher:       publisher,
           node_id:         registry.local_node.id,
           process_request: true)
  end

  let(:node) { double(Moleculer::Node, node_id: "remote", beat: true) }

  let(:subscriptions) { FakeSubscriptions.new }

  subject { Moleculer::Broker::Subscriber.new(broker) }

  describe "#subscribe_to_disconnect" do
    it_behaves_like "subscription", "disconnect"

    let(:packet) { double(Moleculer::Packets::Disconnect, sender: "test") }
    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        subscriptions.subscribe(:disconnect, block)
      end
    end

    it "should remove the node from the registry" do
      subject.subscribe_to_disconnect
      subscriptions.call(:disconnect, packet)
      expect(registry).to have_received(:remove_node).with(packet.sender)
    end
  end

  describe "#subscribe_to_heartbeat" do
    it_behaves_like "subscription", "heartbeat"

    let(:packet) { double(Moleculer::Packets::Heartbeat, sender: "test") }
    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        subscriptions.subscribe(:heartbeat, block)
      end
      subject.subscribe_to_heartbeat
    end

    it "should fetch the node using safe_fetch_node from the registry" do
      subscriptions.call(:heartbeat, packet)
      expect(registry).to have_received(:safe_fetch_node).with(packet.sender)
    end

    context "when a node is present" do
      let(:node) { double(Moleculer::Node, beat: true) }

      before :each do
        allow(registry).to receive(:safe_fetch_node).with("test").and_return(node)
      end

      it "should send a beat to the registered node" do
        subscriptions.call(:heartbeat, packet)
        expect(node).to have_received(:beat)
      end
    end

    context "when a node is not present" do
      before :each do
        allow(registry).to receive(:safe_fetch_node).with("test").and_return(nil)
      end

      it "should publish a discover packet to the node" do
        subscriptions.call(:heartbeat, packet)
        expect(publisher).to have_received(:discover_to_node_id).with("test")
      end
    end
  end

  describe "#subscibe_to_discover" do
    it_behaves_like "subscription", "discover"

    before :each do
      allow(transporter).to receive(:subscribe) do |name, &block|
        subscriptions.subscribe(name.split(".").last.downcase.to_sym, block)
      end
      subject.subscribe_to_discover
    end

    it "should subscribe to MOL.DISCOVER.local" do
      expect(transporter).to have_received(:subscribe).with("MOL.DISCOVER.local")
    end

    context "from remote node" do
      let(:packet) { double(Moleculer::Packets::Heartbeat, sender: "test") }

      it "force sends an info packet to the requesting node" do
        subscriptions.call(:local, packet)
        expect(publisher).to have_received(:info).with("test", true)
      end

      it "publishes the info packet to the remote node" do
        subscriptions.call(:discover, packet)
        expect(publisher).to have_received(:info).with("test")
      end
    end

    context "from local node" do
      let(:packet) { double(Moleculer::Packets::Heartbeat, sender: "local") }

      it "does not publish info packet to the remote node" do
        subscriptions.call(:discover, packet)
        expect(publisher).to_not have_received(:info)
      end
    end
  end

  describe "#subscribe_to_req" do
    let(:packet) { double(Moleculer::Packets::Heartbeat, sender: "test") }

    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        subscriptions.subscribe(:req, block)
      end
      subject.subscribe_to_req
    end

    it_behaves_like "subscription", "req"

    it "calls the request processor" do
      subscriptions.call(:req, packet)
      expect(broker).to have_received(:process_request).with(packet)
    end
  end
end
