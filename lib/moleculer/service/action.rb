# frozen_string_literal: true

module Moleculer
  module Service
    ##
    # Represents a service action
    class Action
      def initialize(name, method, options)
        @name    = name
        @method  = method
        @options = options
      end
    end
  end
end
