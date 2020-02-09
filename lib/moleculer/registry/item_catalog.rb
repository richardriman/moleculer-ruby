# frozen_string_literal: true

module Moleculer
  module Registry
    ##
    # Moleculer catalogs track nodes, services, actions and events
    class ItemCatalog
      def initialize(registry, type)
        @registry = registry
        @broker   = @registry.broker
        @logger   = @registry.logger
        @store    = Concurrent::Hash.new
        @type     = type
      end

      ##
      # register all items for the given node
      #
      # @param node [Moleculer::Node]
      def register_items_for_node(node)
        reset_for_node(node)
        register_items(node.public_send(@type).values)
      end

      private

      def register_items(items)
        items.each { |item| register(item) }
      end

      def register(item)
        @store[item.name] ||= []
        @store[item.name].push(item)
      end

      def reset_for_node(node)
        @store = Concurrent::Hash[@store.map do |name, items|
          [name, items.reject { |i| i.node_id == node.id }]
        end]
      end
    end
  end
end
