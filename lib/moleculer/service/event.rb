# frozen_string_literal: true

module Moleculer
  module Service
    ##
    # Represents a service event
    class Event
      def initialize(name, method, options)
        @name    = name
        @method  = method
        @options = options
      end
    end
  end
end
