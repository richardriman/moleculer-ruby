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

        create_local_node
      end

      ##
      # Add a new node
      #
      # @param node [Node] the node to add
      def add(node)
        @registry.register_services_for_node(node)
      end

      def start_heartbeat_timers; end

      private

      def create_local_node
        node = Node.new(@broker,
                        id:       @broker.node_id,
                        local:    true,
                        ip_list:  Utils.get_ip_list,
                        seq:      1,
                        client:   {
                          type:         "ruby",
                          version:      Moleculer::VERSION,
                          lang_version: RUBY_VERSION,
                        },
                        services: @broker.services)

        add(node)
        @local_node = node
      end
    end
  end
end
