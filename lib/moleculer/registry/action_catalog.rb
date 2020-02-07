# frozen_string_literal: true

module Moleculer
  module Registry
    ##
    # Maintains a registry of available actions
    class ActionCatalog
      def initialize(registry)
        @registry = registry
        @actions  = Concurrent::Hash.new
      end

      ##
      # register all actions for the given nodes
      #
      # @param node [Moleculer::Node]
      def register_actions_for_node(node, is_update)
        register_actions(node.actions.values)
      end

      ##
      # Register all provided actions
      #
      # @param actions [Array<actions>] actions to register
      def register_actions(actions)
        actions.each { |a| register_action(a) }
      end

      ##
      # Registers the handler with the catalog
      #
      # @param handler [Moleculer::Service::Action] the action handler
      def register_action(handler)
        duplicates                    = select_duplicates(handler)
        @actions[handler.name] ||= []
        @actions[handler.name].push(handler)
        remove_handlers(duplicates)
      end

      private

      def remove_handlers(handlers)
        handlers.each { |h| @actions[h.name].delete(h) }
      end

      def select_duplicates(handler)
        @actions[handler.name]&.select { |h| h.service.node.id == handler.service.node.id } || []
      end
    end
  end
end
