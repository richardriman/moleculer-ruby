# frozen_string_literal: true

require "concurrent/actor"

module Moleculer
  module Transporters
    ##
    # Base transporter class
    class Base < Concurrent::Actor::RestartingContext
      def initialize(transit, options = {}, subscriptions)
        @options       = options
        @connected     = false
        @transit       = transit
        @broker        = @transit.broker
        @serializer    = @transit.serializer
        @node_id       = @broker.node_id
        @logger        = @broker.get_logger("transporter")
        @prefix        = "MOL"
        @prefix        += "-#{@broker.namespace}" unless @broker.namespace.empty?
        @subscriptions  = subscriptions
        connect
      end

      def connect
        raise NotImplementedError
      end

      def disconnect
        raise NotImplementedError
      end

      def make_subscriptions
        @subscriptions.each { |topic| subscribe(topic[:type].type, topic[:node_id]) }
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
        parsed = @serializer.deserialize(type, message)
        Packets.resolve(type.split(".")[1]).new(parsed)
      end

      def get_topic_name(type, node_id)
        "#{@prefix}.#{type}#{node_id ? ".#{node_id}" : ''}"
      end

      def on_message(message)
        @transit.handler << deserialize(message[:topic], message[:message])
      end
    end
  end
end
