# frozen_string_literal: true

require_relative "node"

module Moleculer
  module Registry
    ##
    # Catalog for nodes
    class NodeCatalog
      attr_reader :local_node, :nodes

      ##
      # @param registry [Moleculer::Registry] registry
      def initialize(registry)
        @registry = registry
        @broker   = @registry.broker
        @logger   = @registry.logger

        @nodes = Concurrent::Hash.new

        create_local_node
        #
        # @broker.local_bus.on("$transporter.connected") do
        #   set_heartbeat_timers
        # end
        #
        # @broker.local_bus.on("$transporter.disconnected") do
        #   stop_heartbeat_timers
        # end
      end

      ##
      # Add a new node
      #
      # @param node [Node] the node to add
      def add(node)
        @nodes[node.id] = node
      end

      def start_heartbeat_timers; end

      private

      def create_local_node
        node = Node.new(
          id:      @broker.node_id,
          local:   true,
          ip_list: Utils.get_ip_list,
          seq:     1,
          client:  {
            type:         "ruby",
            version:      Moleculer::VERSION,
            lang_version: RUBY_VERSION,
          },
        )

        add(node)

        @local_node = node
      end
    end
  end
end
