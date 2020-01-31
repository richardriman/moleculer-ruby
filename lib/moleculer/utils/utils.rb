# frozen_string_literal: true

require "socket"

module Moleculer
  module Utils
    extend self

    def get_ip_list
      Socket.ip_address_list.map { |info| info.ip_address }
    end

    def get_node_id
      "#{Socket.gethostname}-#{Process.pid}"
    end
  end
end
