# frozen_string_literal: true

require_relative "registry"
require_relative "broker/base"

module Moleculer
  ##
  # Moleculer service broker
  module Broker
    def self.new(options={})
      Base.new(options)
    end
  end
end
