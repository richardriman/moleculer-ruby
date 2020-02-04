# frozen_string_literal: true

module Moleculer
  module Service
    ##
    # Represents a service action
    class Action
      attr_reader :service

      def initialize(service, name, method, options)
        @service  = service
        @raw_name = name
        @method   = method
        @options  = options
      end

      ##
      # Returns the fully qualified action name
      def name
        "#{@service.name}.#{@raw_name}"
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
        return @service.public_send(@method, ctx) if ctx.local && @method

        @service.broker.call(name, ctx.params, options)
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
