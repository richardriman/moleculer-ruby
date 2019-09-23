# frozen_string_literal: true
require_relative "../../../lib/moleculer/transporters/base"

RSpec.describe Moleculer::Broker::Publisher do
  let(:transporter) { double(Moleculer::Transporters::Base, publish: true) }
  let(:broker) do
    double(Moleculer::Broker,
           config:      Moleculer::Configuration.new,
           transporter: transporter,
           logger:      double(Moleculer::Support::LogProxy, trace: true),
           registry:    double(Moleculer::Registry, local_node: double(Moleculer::Node,
                                                                       id:   "test",
                                                                       to_h: { services: [], hostname: "" })))
  end

  subject { Moleculer::Broker::Publisher.new(broker) }

  describe "#event" do
    let(:event) { { event: "test.event", data: {}, broadcast: false } }

    it "publishes an event packet to the transporter" do
      subject.event(event)
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Event))
    end
  end

  describe "#heartbeat" do
    it "publishes a heartbeat packet to the transporter" do
      subject.heartbeat
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Heartbeat))
    end
  end

  describe "#discover" do
    it "publishes an discover packet to the transporter" do
      subject.discover
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Discover))
    end
  end

  describe "#discover_to_node_id" do
    it "publishes an discover packet to the transporter" do
      subject.discover_to_node_id("test")
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Discover))
    end
  end

  describe "#info" do
    it "publishes an info packet to the transporter" do
      subject.info
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Info))
    end
  end

  describe "#req" do
    it "publishes an info packet to the transporter" do
      subject.req(id: "anid", action: "test", data: {}, meta: {}, params: {})
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Req))
    end
  end

  describe "#res" do
    it "publishes an info packet to the transporter" do
      subject.res(id: "anid", success: true, data: {}, meta: {})
      expect(transporter).to have_received(:publish)
        .with(instance_of(Moleculer::Packets::Res))
    end
  end
end
