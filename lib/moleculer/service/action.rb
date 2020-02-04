# frozen_string_literal: true

module Moleculer
  module Service
    ##
    # Represents a service action
    class Action
      def initialize(service, name, method, options)
        @service = service
        @name    = name
        @method  = method
        @options = options
      end

      def call(ctx, options)
        return @service.public_send(@method, ctx) if ctx.local && @method

        @service.broker.call("#{@service.name}.#{@name}", ctx.params, options)
      end
    end
  end
end
