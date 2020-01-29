# frozen_string_literal: true

require_relative "retryable_error"

module Moleculer
  module Errors
    ##
    # Error class
    class ProtocolMismatchError < RetryableError
      def initialize(data)
        super("Protocol version mismatch.", 500, "PROTOCOL_VERSION_MISMATCH", data)
      end
    end
  end
end
