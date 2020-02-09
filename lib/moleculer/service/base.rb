# frozen_string_literal: true

require_relative "dsl"
require_relative "../context"

module Moleculer
  module Service
    ##
    # Service class
    class Base
      attr_reader :node, :actions, :version, :events

      include DSL

      def initialize(broker, node)
        @broker  = broker
        @node    = node
        @actions = ::Hash[self.class.actions.map do |a|
          action = Action.new(self, a[:name], a[:method], a[:options])
          [action.name, action]
        end]
        @events = {}
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

      def service_name
        self.class.service_name
      end
      alias_method :name, :service_name

    end
  end
end
