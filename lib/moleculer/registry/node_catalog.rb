# frozen_string_literal: true

module Moleculer
  module Registry
    ##
    # Catalog for nodes
    class NodeCatalog

      ##
      # @param registry [Moleculer::Registry] registry
      # @param broker [Moleculer::Broker] broker
      def initialize(registry, broker)
        @registry = registry
        @broker   = broker
        @logger   = @registry.logger

        @nodes = Concurrent::Hash.new

        create_local_node
      end

      ##
      # Create local node with local information
      #
      # @return [Node] the local node
      def create_local_node
        node         = Node.new(@broker.node_id)
        node.local   = true
        node.ip_list = Utils.get_ip_list
        node.seq     = 1
        node.client  = {
          type:         "ruby",
          version:      Moleculer::VERSION,
          lang_version: RUBY_VERSION,
        }

        add(node.id, node)

        @local_node = node
      end

      ##
      # Add a new node
      #
      # @param id [String] the node id
      # @param node [Node] the node to add
      def add(node_id, node)
        @nodes[node_id] = node
      end
    end
  end
end
