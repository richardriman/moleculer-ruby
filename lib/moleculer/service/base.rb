# frozen_string_literal: true

require_relative "dsl"
require_relative "../context"

module Moleculer
  module Service
    ##
    # Service class
    class Base
      attr_reader :node, :actions, :version, :events, :broker

      include DSL

      def initialize(broker, node)
        @broker  = broker
        @node    = node
        @actions = ::Hash[self.class.actions.map do |a|
          action = Action.new(self, a[:name], a[:method], a[:options])
          [action.name, action]
        end]
        @events  = ::Hash[self.class.events.map do |e|
          event = Event.new(self, e[:name], e[:method], e[:options])
          [event.name, event]
        end]
      end

      ##
      # @return [::Hash] the service schema
      def schema
        {
          name:     service_name,
          settings: {},
          metadata: {},
          actions:  ::Hash[actions.values.map { |a| [a.name.to_sym, a.schema] }],
          events:   {},
        }
      end

      def node_id
        @node.id
      end

      def service_name
        self.class.service_name
      end
      alias name service_name
    end
  end
end
