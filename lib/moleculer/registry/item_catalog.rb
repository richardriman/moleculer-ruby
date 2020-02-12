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

      def unregister_items_for_node(node)
        reset_for_node(node)
      end

      def get_items_by_groups(name, groups)
        items = if !groups.empty?
                  select_from_groups(groups)
                else
                  @store.values
                end
        items.flatten.select { |item| item.name == name }
      end

      def get_items_by_groups_for_node(name, groups, node_id)
        get_items_by_groups(name, groups).select { |item| item.node_id == node_id }
      end

      private

      def select_from_groups(groups)
        @store.reject { |item| (item.options[:groups] && groups).empty? }
      end

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
