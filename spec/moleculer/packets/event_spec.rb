# frozen_string_literal: true

require_relative "./base_packet_behavior"

RSpec.describe Moleculer::Packets::Event do
  let(:broker) do
    Moleculer::Broker.new(Moleculer::Configuration.new(
                            node_id:     "test1",
                            services:    [],
                            log_level:   "trace",
                            transporter: "fake://localhost",
                          ))
  end

  let(:node) { double("node", id: 1)}

  subject { Moleculer::Packets::Event.new(broker.config, event: "test", data: {}, broadcast: false, node: node) }

  include_examples "base packet"

  describe "#topic" do
    it "includes the node id" do
      expect(subject.topic).to eq("MOL.EVENT.1")
    end
  end
end
