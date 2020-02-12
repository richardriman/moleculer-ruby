# frozen_string_literal: true

module Moleculer
  module Service
    ##
    # Represents a service action
    class Action
      attr_reader :service, :option

      def initialize(service, name, method, options)
        @service  = service
        @raw_name = name
        @method   = method
        @options  = options
      end

      ##
      # Returns the fully qualified action name
      def name
        "#{@service.service_name}.#{@raw_name}"
      end

      ##
      # @return [String] the node id for this action
      def node_id
        @service.node.id
      end

      ##
      # Calls the action, if the action is a local call it will call the method on the service, otherwise it will
      # call against the broker
      #
      # @param ctx [Moleculer::Context]
      # @param options [::Hash] call options
      #
      # @return [any] result of the call
      def call(ctx, options)
        @service.public_send(@method, ctx) if ctx.local && @method
      end

      ##
      # Returns the action schema
      def schema
        {
          cache:    false,
          params:   {},
          raw_name: @raw_name,
          name:     name,
          metrics:  {
            params: false,
            meta:   true,
          },
        }
      end
    end
  end
end
