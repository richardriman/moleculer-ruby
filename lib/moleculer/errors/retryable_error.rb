# frozen_string_literal: true

require_relative "error"

module Moleculer
  module Errors
    ##
    # A retryable error can be retried
    class RetryableError < Error
      def initialize(message, code, type, data)
        super
        @code ||= 500
        @retryable = true
      end
    end
  end
end
