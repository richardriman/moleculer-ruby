# frozen_string_literal: true
#
require_relative "packets/disconnect"
require_relative "packets/discover"
require_relative "packets/event"
require_relative "packets/heartbeat"
require_relative "packets/info"
require_relative "packets/ping"
require_relative "packets/pong"
require_relative "packets/req"
require_relative "packets/res"




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
