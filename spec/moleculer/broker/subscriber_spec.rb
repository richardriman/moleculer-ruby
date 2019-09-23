# frozen_string_literal: true

require_relative "../../../lib/moleculer/transporters/base"

RSpec.describe Moleculer::Broker::Subscriber do
  let(:registry) do
    double(Moleculer::Registry, local_node:      double(Moleculer::Node,
                                                        id:   "test",
                                                        to_h: { services: [], hostname: "" }),
                                remove_node:     true,
                                safe_fetch_node: node)
  end
  let(:transporter) { double(Moleculer::Transporters::Base, subscribe: true) }
  let(:broker) do
    double(Moleculer::Broker,
           config:      Moleculer::Configuration.new,
           transporter: transporter,
           logger:      double(Moleculer::Support::LogProxy, trace: true),
           registry:    registry)
  end

  let(:node) { double(Moleculer::Node, beat: true) }

  subject { Moleculer::Broker::Subscriber.new(broker) }

  describe "#subscribe_to_disconnect" do
    let(:packet) { double(Moleculer::Packets::Disconnect, sender: "test") }
    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        @subscriber = block
      end
    end

    it "should subscribe to the disconnect channel" do
      subject.subscribe_to_disconnect
      expect(transporter).to have_received(:subscribe).with("MOL.DISCONNECT")
    end

    it "should remove the node from the registry" do
      subject.subscribe_to_disconnect
      @subscriber.call(packet)
      expect(registry).to have_received(:remove_node).with(packet.sender)
    end
  end

  describe "#subscribe_to_heartbeat" do
    let(:packet) { double(Moleculer::Packets::Heartbeat, sender: "test") }
    before :each do
      allow(transporter).to receive(:subscribe) do |_, &block|
        @subscriber = block
      end
    end

    it "should subscribe to the heartbeat channel" do
      subject.subscribe_to_heartbeat
      expect(transporter).to have_received(:subscribe).with("MOL.HEARTBEAT")
    end

    it "should fetch the node using safe_fetch_node from the registry" do
      subject.subscribe_to_heartbeat
      @subscriber.call(packet)
      expect(registry).to have_received(:safe_fetch_node).with(packet.sender)
    end
  end
end
