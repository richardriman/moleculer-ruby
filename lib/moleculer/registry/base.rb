# frozen_string_literal: true

require_relative "node_catalog"
require_relative "item_catalog"

module Moleculer
  module Registry
    ##
    # Node registry
    class Base
      attr_reader :broker, :logger

      ##
      # @param broker [Moleculer::Broker] the moleculer service broker
      def initialize(broker, options = {})
        @broker          = broker
        @logger          = @broker.get_logger("registry")
        @options         = (options[:registry] || {}).dup
        @service_catalog = ItemCatalog.new(self, :services)
        @node_catalog    = NodeCatalog.new(self)
      end

      ##
      # Registers all associated services for the given node.
      #
      # @param node [Moleculer::Node] the node to register
      def register_services_for_node(node)
        @service_catalog.register_items_for_node(node)
      end

      ##
      # @return [Moleculer::Node] the local moleculer node
      def local_node
        @node_catalog.local_node
      end
    end
  end
end
