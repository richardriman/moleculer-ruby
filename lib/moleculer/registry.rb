# frozen_string_literal: true

require_relative "registry/base"

module Moleculer
  ##
  # Node registry
  module Registry
    def self.new(broker, options = {})
      Base.new(broker, options)
    end
  end
end
