# frozen_string_literal: true

require_relative "packet"

module Moleculer
  ##
  # Transit class
  class Transit
    def initialize(broker, transporter, options)
      @broker        = broker
      @transporter   = transporter
      @options       = options
      @logger        = @broker.get_logger("transit")
      @connected     = false
      @disconnecting = false
      @is_ready      = true
    end
  end
end
