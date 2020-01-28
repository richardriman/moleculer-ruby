# frozen_string_literal: true

require_relative "base"

module Moleculer
  module Transporters
    ##
    # Redis transporter
    class Redis < Base
      class << self
        attr_writer :hi_redis

        def hi_redis
          @hi_redis ||= false
        end
      end

      def connect(reconnect = false)
        @sub = Redis.new(@options)
        @pub = Redis.new(@options)
        on_connect(reconnect)
      end

      def subscribe(cmd, node_id)
        @sub.subscribe(cmd, node_id) do |on|
          on.message do |topic, message|
            handle_message(topic, message)
          end
        end
      end
    end
  end
end
