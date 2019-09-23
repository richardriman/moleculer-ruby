# frozen_string_literal: true

module Moleculer
  class Broker
    ##
    # Handles the subscribing to messages through the transporter
    class Subscriber
      def initialize(broker)
        @broker = broker
      end

      ##
      # Starts all of the subscribers
      def start
        subscribe_to_info
        subscribe_to_res
        subscribe_to_req
        subscribe_to_events
        subscribe_to_discover
        subscribe_to_disconnect
        subscribe_to_heartbeat
      end

      ##
      # Subscribes to disconnect messages
      def subscribe_to_disconnect
        @broker.logger.trace "setting up 'DISCONNECT' subscriber"
        subscribe("MOL.DISCONNECT") do |packet|
          @broker.registry.remove_node(packet.sender)
        end
      end

      ##
      # Subscribes to heartbeats from other services. If a node is not registered when it received a heartbeat the
      # broker will send a discover packet directly to the node that published the beat.
      def subscribe_to_heartbeat
        @broker.logger.trace "setting up 'HEARTBEAT' subscriber"
        subscribe("MOL.HEARTBEAT") do |packet|
          node = @broker.registry.safe_fetch_node(packet.sender)
          if node
            node.beat
          else
            # because the node is not registered with the broker, we have to assume that something broke down. we need
            # to force a publish to the node we just received the heartbeat from
            @broker.publisher.discover_to_node_id(packet.sender)
          end
        end
      end

      ##
      # Subscribes to discover packets.
      def subscribe_to_discover
        @broker.logger.trace "setting up 'DISCOVER' subscriber"
        subscribe("MOL.DISCOVER") do |packet|
          @broker.publisher.publish_info(packet.sender) unless packet.sender == node_id
        end
        subscribe("MOL.DISCOVER.#{node_id}") do |packet|
          @broker.publisher.publish_info(packet.sender, true)
        end
      end

      ##
      # Subscribes to RPC request packets
      def subscribe_to_req
        @broker.logger.trace "setting up 'REQ' subscriber"
        subscribe("MOL.REQ.#{node_id}") do |packet|
          process_request(packet)
        end
      end

      ##
      # Subscribe to RPC responses
      def subscribe_to_res
        @broker.logger.trace "setting up 'RES' subscriber"
        subscribe("MOL.RES.#{node_id}") do |packet|
          MessageProcessor.process_rpc_response(@broker.contexts.delete(packet.id), packet)
        end
      end

      ##
      # Subscribe to events
      def subscribe_to_events
        @broker.logger.info "setting up 'EVENT' subscriber"
        subscribe("MOL.EVENT.#{node_id}") do |packet|
          process_event(packet)
        end
      end

      ##
      # Subscribe to info packets
      def subscribe_to_info
        @broker.logger.trace "setting up 'INFO' subscribers"
        subscribe("MOL.INFO.#{node_id}") do |packet|
          register_or_update_remote_node(packet)
        end
        subscribe("MOL.INFO") do |packet|
          register_or_update_remote_node(packet)
        end
      end

      private

      def subscribe(channel, &block)
        @broker.transporter.subscribe(channel, &block)
      end
    end
  end
end
