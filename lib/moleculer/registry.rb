# frozen_string_literal: true

require_relative "registry/base"

module Moleculer
  ##
  # Node registry
  module Registry
    def self.new(broker)
      Base.new(broker)
    end
  end
end
