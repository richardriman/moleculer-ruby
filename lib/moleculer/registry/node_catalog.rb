# frozen_string_literal: true

require "concurrent/timer_task"

require_relative "../node"

module Moleculer
  module Registry
    ##
    # Catalog for nodes
    class NodeCatalog
      attr_reader :local_node

      ##
      # @param registry [Moleculer::Registry] registry
      def initialize(registry)
        @registry = registry
        @broker   = @registry.broker
        @logger   = @registry.logger

        @nodes = Concurrent::Hash.new
        start_heartbeat_timers
      end

      ##
      # Add a new node
      #
      # @param node [Node] the node to add
      def add(node)
        existing_node  = get(node.id)
        is_reconnected = false

        @nodes[node.id] = node
        @local_node     = node if node.id == @broker.node_id

        if !existing_node
          @logger.info "Node '#{node.id}' connected."
        elsif !node.available
          is_reconnected = true
          node.beat
          @logger.info "Node '#{node.id}' reconnected."
        else
          @logger.debug "Node '#{node.id}' updated."
        end
      end

      def get(node_id)
        @nodes[node_id]
      end

      private

      def start_heartbeat_timers
        @heartbeat_timer = Concurrent::TimerTask.execute(execution_interval: @broker.options[:heartbeat_interval]) do
          transit.send_heartbeat
        end

        @check_nodes_timer = Concurrent::TimerTask.execute(execution_interval: @broker.options[:heartbeat_timeout]) do
          check_remote_nodes
        end

        @offline_timer = Concurrent::TimerTask.execute(execution_interval: 30) do
          check_offline_nodes
        end
      end

      def disconnected(node, unexpected)
        return unless node.available

        node.disconnected(unexpected)
        @registry.unregister_services_for_node(node)
        @logger.warn("Node '#{node.id}' disconnected #{unexpected ? 'unexpectedly' : ''}.")
      end

      def check_offline_nodes
        now = Time.now

        @nodes.values.each do |node|
          next if node.local || node.available

          if now - node.last_heartbeat_time > 60
            @logger.warn("Remove offline '#{node.id}' node from registry because it hasn't submitted heartbeat signal for 10 minutes.");
            return @nodes.delete(node.id)
          end
        end
      end

      def check_remote_nodes
        now = Time.now

        @nodes.values.each do |node|
          next if node.local || !node.available

          if now - node.last_heartbeat_time > @broker.options[:heartbeat_timeout]
            @logger.warn"Heartbeat not received from '#{node.id}' node."
            disconnected(node, true)
          end
        end
      end

      def transit
        @broker.transit
      end
    end
  end
end
