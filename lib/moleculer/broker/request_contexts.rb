# frozen_string_literal: true

module Moleculer
  class Broker
    ##
    # Helper class to manage request contexts. Also handles garbage collection of stale contexts.
    class RequestContexts
      def initialize(broker)
        @broker   = broker
        @contexts = Concurrent::Hash.new
        @cleaner  = Concurrent::TimerTask.new(execution_interval: @broker.config.timeout) do
          delete_stale_contexts
        end.execute
      end

      ##
      # Adds the context to the list
      #
      # @param [Moleculer::Broker::RequestContext] context the context to add to the list
      def <<(context)
        @contexts[context.id] = context
      end

      ##
      # Find sand removes the context of the provided id
      #
      # @param [string] id the id of the context to fetch
      def pop(id)
        @contexts.delete(id)
      end

      private

      def delete_stale_contexts
        # @contexts.delete_if do |_, v|
        #   v.created_at.to_i < (@broker.config.timeout * 2) + Time.now.to_i
        # end
      end
    end
  end
end
