# frozen_string_literal: true

require_relative "request_context"

module Moleculer
  class Broker
    ##
    # A Helper that encapsulates message processing logic
    # @private
    class MessageProcessor
      extend Forwardable

      def_delegators :@broker, :config, :publisher, :node_id

      def initialize(broker)
        @broker = broker
      end

      ##
      # Processes an RPC response
      # @param packet [Packet::Base] the message packet
      def process_rpc_response(context, packet)
        context.fulfill(packet.data)
      end

      private

      def action_for_packet(packet)
        @broker.fetch_action_for_node_id(packet.action, node_id)
      end

      def node_for_packet(packet)
        @broker.fetch_node(packet.sender)
      end
    end
  end
end
