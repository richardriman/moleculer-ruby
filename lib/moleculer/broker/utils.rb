require "socket"

module Moleculer
  module Broker
    module Utils
      extend self

      def get_node_id
        "#{Socket.gethostname}-#{Process.pid}"
      end
    end
  end
end
