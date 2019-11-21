# frozen_string_literal: true

module Moleculer
  class Broker
    ##
    # @private
    class Publisher
      def initialize(config:, local_node:, transporter:, logger:)
        @config      = config
        @local_node  = local_node
        @transporter = transporter
        @logger      = logger
      end

      def publish(packet_type, message = {})
        publish_to_node_id(packet_type, @local_node.id, message)
      end

      def publish_discover
        publish(:discover)
      end

      def publish_discover_to_node_id(node_id)
        publish_to_node_id(:discover, node_id)
      end

      def publish_event(event_data)
        publish_to_node(:event, event_data.delete(:node), event_data)
      end

      def publish_heartbeat
        publish(:heartbeat)
      end

      def publish_info
        publish(:info, @local_node.to_h)
      end

      def publish_info_to_node_id(node_id)
        publish_to_node_id(:info, node_id, @local_node.to_h)
      end

      def publish_req(request_data)
        publish_to_node_id(:req, request_data.delete(:node).id, request_data)
      end

      def publish_res(response_data)
        publish_to_node_id(:res, response_data.delete(:node).id, response_data)
      end

      private

      def publish_info_to_node(node_id)
        publish_to_node_id(:info, node_id, @local_node.to_h)
      end

      def publish_to_node_id(packet_type, node_id, message = {})
        packet = Packets.for(packet_type).new(@config, message.merge(node_id: node_id))
        @transporter.publish(packet)
      end

    end
  end
end
