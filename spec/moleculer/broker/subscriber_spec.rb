# frozen_string_literal: true

require_relative "../../../lib/moleculer/transporters/base"

RSpec.describe Moleculer::Broker::Subscriber do
  let(:registry) { double(Moleculer::Registry, subscribe: true) }
  let(:transporter) { double(Moleculer::Transporters::Base, subscribe: true) }
  let(:broker) do
    double(Moleculer::Broker,
           config:      Moleculer::Configuration.new,
           transporter: transporter,
           logger:      double(Moleculer::Support::LogProxy, trace: true),
           registry:    double(Moleculer::Registry, local_node: double(Moleculer::Node,
                                                                       id:   "test",
                                                                       to_h: { services: [], hostname: "" })))
  end

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
      expect(registry).to have_received(:subscribe).with("MOL.DISCONNECT", @subscriber)
    end
  end
end
