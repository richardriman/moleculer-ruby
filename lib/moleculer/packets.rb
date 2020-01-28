# frozen_string_literal: true
#
require_relative "packets/info"

module Moleculer
  ##
  # Packets
  module Packets
    extend self

    ##
    # Resolves the packet from the packet type
    def resolve(name)
      const_get(name.to_sym)
    end
  end
end
