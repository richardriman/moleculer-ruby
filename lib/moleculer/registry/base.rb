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

      def register_node(node)
        @nodes[node.id] = node
      end

      def node?(node)
        return @nodes[node] && true if node.is_a?(String)

        node?(node.id)
      end

    end
  end
end
