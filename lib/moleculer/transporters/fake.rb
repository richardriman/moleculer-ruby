# frozen_string_literal: true

module Moleculer
  module Transporters
    ##
    # Fake transporter for testing
    class Fake
      def connect
        true
      end
    end
  end
end
