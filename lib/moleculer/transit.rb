# frozen_string_literal: true

require "concurrent/actor"

require_relative "packets"

module Moleculer
  ##
  # Transit class
  class Transit
    ##
    # The transit handler simply handles the processing of incoming messages asynchronously
    class Handler < Concurrent::Actor::RestartingContext
      def initialize(transit)
        @transit = transit
      end

      def on_message(message)
        if message.payload[:ver] != Moleculer::PROTOCOL_VERSION
          raise(
            Errors::ProtocolMismatchError,
            node_id:  message.payload[:sender],
            actual:   Moleculer::PROTOCOL_VERSION,
            received: message.payload[:ver],
          )
        end
        case message
        when Packets::DISCOVER
          @transit.send_node_info(message.payload[:sender])
        when Packets::INFO
          @transit.process_node_info(message)
        end
      end
    end

    attr_reader :broker, :serializer, :handler, :logger

    def initialize(broker, options)
      @broker            = broker
      @options           = options
      @registry          = broker.registry
      @transporter       = @broker.transporter
      @registry          = @broker.registry
      @logger            = @broker.get_logger("transit")
      @connected         = false
      @disconnecting     = false
      @is_ready          = true
      @serializer        = @broker.serializer
      @node_id           = @broker.node_id
      @disable_reconnect = @options[:disable_reconnect]
      @handler           = Handler.spawn(:handler, self)
    end

    def connect
      @logger.info("Connecting to the transporter...")
      t            = @transporter.new(self, @broker.options[:transporter], subscriptions)
      @transporter = t # prevents @transporter from being assigned when an exception happens
      send_node_info
      send_discover
    # rescue StandardError => e
    #   @logger.warn("Connection is failed. #{e.message}")
    #   @logger.debug(e)
    #   return if @disable_reconnect

      # retry
    end

    def subscriptions
      [
        { type: Packets::DISCONNECT, node_id: @node_id },
        { type: Packets::DISCOVER },
        { type: Packets::DISCOVER, node_id: @node_id },
        { type: Packets::EVENT, node_id: @node_id },
        { type: Packets::HEARTBEAT, node_id: @node_id },
        { type: Packets::INFO, node_id: @node_id },
        { type: Packets::INFO },
        { type: Packets::PING },
        { type: Packets::PING, node_id: @node_id },
        { type: Packets::PONG, node_id: @node_id },
      ]
    end

    def send_node_info(sender = nil)
      @transporter.publish(Packets::INFO.new(@broker.registry.local_node.schema), sender)
    end

    def send_discover(sender = nil)
      @transporter.publish(Packets::DISCOVER.new, sender)
    end

    def process_node_info(packet)
      @registry.process_node_info(packet)
    end
  end
end
