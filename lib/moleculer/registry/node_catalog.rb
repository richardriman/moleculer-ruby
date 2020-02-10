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
        existing_node           = get(node.id)
        is_reconnected = false

        @nodes[node.id] = node
        @local_node = node if node.id == @broker.node_id

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

      def start_heartbeat_timers
        @heartbeat_timer = Concurrent::TimerTask.new(run_now: true, execution_interval: @broker.options[:heartbeat_interval]) do
          transit.send_heartbeat
        end
        @heartbeat_timer.execute
      end

      private

      def transit
        @broker.transit
      end
    end
  end
end
