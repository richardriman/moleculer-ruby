# frozen_string_literal: true

require_relative "error"

module Moleculer
  module Errors
    ##
    # Error class for server error which is retryable.
    class ServerError < RetryableError
    end
  end
end
