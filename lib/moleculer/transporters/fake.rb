# frozen_string_literal: true

require_relative "base"

module Moleculer
  module Transporters
    ##
    # Fake transporter for testing
    class Fake < Base
      def connect
        on_connect(false)
      end
    end
  end
end
