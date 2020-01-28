# frozen_string_literal: true

class Moleculer
  module Errors
    ##
    # Moleculer error class
    class Error < StandardError
      def initialize(message, code, type, data)
        super(message)
        @message = message
        @code    = code
        @type    = type
        @data    = data
      end
    end
  end
end
