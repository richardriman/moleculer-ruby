# frozen_string_literal: true

require_relative "broker/base"
require_relative "broker/local_event_bus"

module Moleculer
  ##
  # Moleculer service broker
  module Broker
    def self.new(options={})
      Base.new(options)
    end
  end
end
