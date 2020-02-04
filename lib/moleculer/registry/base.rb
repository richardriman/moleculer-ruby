# frozen_string_literal: true

require_relative "node_catalog"
require_relative "service_catalog"
require_relative "event_catalog"
require_relative "action_catalog"

module Moleculer
  module Registry
    ##
    # Node registry
    class Base
      attr_reader :broker

      ##
      # @param broker [Moleculer::Broker] the moleculer service broker
      def initialize(broker, options = {})
        @broker  = broker
        @logger  = @broker.get_logger("registry")
        @options = (options[:registry] || {}).dup
        @nodes   = {}
      end

      ##
      # Registers the node
      #
      # @param node [Moleculer::Node]
      def register_node(node)
        @nodes[node.id] = node
      end

      ##
      # Register the local node
      #
      # @param node [Moleculer::Node] the local node
      def register_local_node(node)
        raise ArgumentError, "node is not local" unless node.local

        raise ArgumentError, "local node already registered" if @local_node

        @local_node = node
        register_node(node)
      end

      ##
      # Returns true or false if the node exists in the registry
      #
      # @param node [Moleculer::Node|String] the node or the id of the node to determine if exists
      def node?(node)
        return @nodes[node] && true if node.is_a?(String)

        node?(node.id)
      end

    end
  end
end
