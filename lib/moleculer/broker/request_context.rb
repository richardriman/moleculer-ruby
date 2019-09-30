# frozen_string_literal: true

module Moleculer
  class Broker
    ##
    # Encapsulates the context of a single RPC request
    class RequestContext
      attr_reader :id, :created_at, :action, :params, :parent_id, :meta, :timeout, :request_id

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
        @request_id = SecureRandom.uuid
      end

      def fulfill(value)
        @result.resolve(value)
      end

      ##
      # Calls the context block, returns the result of the call
      #
      # @return [Hash]
      def call
        @result = @action.execute(self, @broker)

        return @result unless @result.is_a?(Concurrent::Promises::Future)

        @result.value!(@timeout)
      end
    end
  end
end
