# frozen_string_literal: true

module Moleculer
  module Registry
    class Node
      attr_writer :local, :ip_list, :hostname, :client, :seq

      def initialize(id)
        @id                  = id
        @available           = true
        @local               = false
        @last_heartbeat_time = Time.now
        @config              = {}
        @client              = {}

        @services = []

        @seq = 0
      end

      def update(payload, is_reconnected)
        @ip_list  = payload[:ip_list]
        @hostname = payload[:hostname]
        @port     = payload[:port]
        @client   = payload[:client] || {}
        @services = payload[:services]
        @raw_info = payload

        new_seq = payload[:seq] || 1

        @seq = new_seq if new_seq > @seq || is_reconnected
      end

      def update_local_info(cpu_usage); end

      def heartbeat(payload)
        unless @available
          @available     = true
          @offline_since = nil
        end

        @cpu     = payload[:cpu]
        @cpu_seq = payload[:cpu_seq]

        @last_heartbeat_time = Time.now
      end

      def disconnect
        if @available
          @offline_since = Time.now
          @seq          += 1
        end

        @available = false
      end
    end
  end
end
