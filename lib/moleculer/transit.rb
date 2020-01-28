# frozen_string_literal: true

require_relative "packets"

module Moleculer
  ##
  # Transit class
  class Transit
    def initialize(broker)
      @broker        = broker
      @transporter   = @broker.transporter
      @logger        = @broker.get_logger("transit")
      @connected     = false
      @disconnecting = false
      @is_ready      = true
      @serializer    = @broker.serializer
      @node_id       = @broker.node_id
    end

    def serialize(packet)
      packet.payload[:sender] = @node_id
      @serializer.serialize(packet.as_json)
    end

  end
end
