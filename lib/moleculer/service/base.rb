# frozen_string_literal: true

require_relative "dsl"

module Moleculer
  module Service
    ##
    # Service class
    class Base
      include DSL

      def initialize(broker, options={})
        @broker  = broker
      end



    end
  end
end
