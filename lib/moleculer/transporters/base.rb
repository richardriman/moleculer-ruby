# frozen_string_literal: true

module Moleculer
  module Transporters
    ##
    # Base transporter class
    class Base
      attr_writer :transit

      def initialize(broker, options = {})
        @options   = options
        @connected = false
        @broker    = broker
        @node_id   = @broker.node_id
        @logger    = @broker.get_logger("transporter")
        @prefix    = "MOL"
        @prefix   += "-#{@broker.namespace}" if @broker.namespace
      end

      def after_connect(_reconnect); end

      def connect
        raise NotImplementedError
      end

      def disconnect
        raise NotImplementedError
      end

      def on_connect(reconnect)
        @connected = true
        after_connect(reconnect)
      end

      def subscribe(_cmd, _node_id)
        raise NotImplementedError
      end

      private

      def serialize(packet)
        packet.payload[:sender] = @node_id
        @serializer.serialize(packet.as_json)
      end

      def deserialize(type, message)
        @serializer.deserialize(type, message)
      end

      def get_topic_name(type, node_id)
        "#{@prefix}.#{type}#{node_id ? ".#{node_id}" : ''}"
      end

      def handle_message(type, message)
        return unless message
        packet = deserialize(type, message)
      end
    end
  end
end
