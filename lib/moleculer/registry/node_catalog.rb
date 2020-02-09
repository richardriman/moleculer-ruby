# frozen_string_literal: true

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
      end

      ##
      # Add a new node
      #
      # @param node [Node] the node to add
      def add(node)
        @nodes[node.id] = node
        if @broker.node_id == node.id
          @local_node = node
        end
      end

      def start_heartbeat_timers; end
    end
  end
end
