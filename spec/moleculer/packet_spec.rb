# frozen_string_literal: true

RSpec.describe Moleculer::Packet do
  subject { Moleculer::Packet }

  PACKETS = {
      UNKNOWN:      "???",
      EVENT:        "EVENT",
      REQUEST:      "REQ",
      RESPONSE:     "RES",
      DISCOVER:     "DISCOVER",
      INFO:         "INFO",
      DISCONNECT:   "DISCONNECT",
      HEARTBEAT:    "HEARTBEAT",
      PING:         "PING",
      PONG:         "PONG",

      GOSSIP_REQ:   "GOSSIP_REQ",
      GOSSIP_RES:   "GOSSIP_RES",
      GOSSIP_HELLO: "GOSSIP_HELLO",
  }.freeze

  PACKETS.each do |const, val|
    it "should map #{const} to #{val}" do
      expect(subject.const_get(const)).to eq(val)
    end
  end
end
