# frozen_string_literal: true

require "concurrent/actor"
require "concurrent/hash"

module Moleculer
  module Broker
    ##
    # Handles local events
    class LocalEventBus
      # @private
      class InternalBus < Concurrent::Actor::RestartingContext
        def initialize
          @listeners = Concurrent::Hash.new
        end

        def on_message(message)
          case message[:block]
          when Proc
            @listeners[message[:event]] ||= []
            @listeners[message[:event]] << message[:block]
          when nil
            @listeners[message[:event]]&.each { |l| l.call(*message[:args])}
          end
        end
      end

      def initialize
        @internal_bus = InternalBus.spawn(:bus)
      end

      def on(event, &block)
        @internal_bus << {event: event, block: block}
      end

      def broadcast(event, *args)
        @internal_bus << {event: event, args: args}
      end

    end
  end
end
