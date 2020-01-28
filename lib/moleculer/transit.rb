# frozen_string_literal: true

require_relative "packets"

module Moleculer
  ##
  # Transit class
  class Transit
    def initialize(broker, options)
      @broker              = broker
      @options             = options
      @transporter         = @broker.transporter
      @transporter.transit = self
      @logger              = @broker.get_logger("transit")
      @connected           = false
      @disconnecting       = false
      @is_ready            = true
      @serializer          = @broker.serializer
      @node_id             = @broker.node_id
      @disable_reconnect   = @options[:disable_reconnect]
    end

    def connect
      @logger.info("Connecting to the transporter...")
      @transporter.connect
    rescue StandardError => e
      @logger.warn("Connection is failed. #{e.message}")
      @logger.debug(e)
      return if @disable_reconnect

      retry
    end
  end
end
