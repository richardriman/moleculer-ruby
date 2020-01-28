# frozen_string_literal: true

module Moleculer
  ##
  # Packet for transporters
  class Packet
    UNKNOWN    = "???"
    EVENT      = "EVENT"
    REQUEST    = "REQ"
    RESPONSE   = "RES"
    DISCOVER   = "DISCOVER"
    INFO       = "INFO"
    DISCONNECT = "DISCONNECT"
    HEARTBEAT  = "HEARTBEAT"
    PING       = "PING"
    PONG       = "PONG"

    GOSSIP_REQ   = "GOSSIP_REQ"
    GOSSIP_RES   = "GOSSIP_RES"
    GOSSIP_HELLO = "GOSSIP_HELLO"

    attr_reader :payload

    def initialize(type, target, payload)
      @type    = type || UNKNOWN
      @target  = target
      @payload = payload || {}
    end
  end
end
