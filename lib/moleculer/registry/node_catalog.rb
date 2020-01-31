# frozen_string_literal: true

module Moleculer
  module Registry
    class NodeCatalog
      def initialize(registry, broker)
        @registry = registry
        @broker   = broker
        @logger   = @registry.logger

        @nodes = {}
      end

      def create_local_node
        node       = Node.new(@broker.node_id)
        node.local = true
      end

      def add(node_id, node)
        @nodes[node_id] = node
      end
    end
  end
end
