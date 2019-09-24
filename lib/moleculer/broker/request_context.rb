# frozen_string_literal: true

module Moleculer
  class Broker
    ##
    # Encapsulates the context of a single RPC request
    class RequestContext
      attr_reader :id, :created_at
      def initialize(broker:, action:, params:, meta:, parent_id: nil, level: 1, timeout:, id: nil)
        @id         = id || SecureRandom.uuid
        @broker     = broker
        @action     = action
        @params     = params
        @meta       = meta
        @parent_id  = parent_id
        @level      = level
        @timeout    = timeout
        @created_at = Time.now
      end

      ##
      # Calls the context block, returns the result of the call
      def call
        # By scheduling this as a future it will run threaded, the request for #value! will block until the timeout
        # occurs and raise on timeout.
        Concurrent::Promises.future do
          @action.execute(self, @broker)
        end.value!(@timeout)
      end
    end
  end
end
