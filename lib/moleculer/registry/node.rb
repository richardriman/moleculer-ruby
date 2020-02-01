# frozen_string_literal: true

module Moleculer
  module Registry
    ##
    # Node class
    class Node
      attr_reader :local, :ip_list, :hostname, :client, :seq, :id

      ##
      # Creates an instance of Node
      #
      # @param options [Hash]
      def initialize(options)
        @id                  = options[:id]
        @available           = true
        @local               = options[:local]
        @last_heartbeat_time = Time.now
        @ip_list             = options[:ip_list]
        @hostname            = options[:hostname]
        @seq                 = options[:seq]
        @client              = options[:client].dup
        @config              = {}
        @client              = {}

        @services = []

        @seq = 0
      end

      ###
      # Updates properties
      #
      # @param payload [Hash] the schema payload
      # @param is_reconnected [Boolean] whether or not the node is updated due to a reconnect
      def update(payload, is_reconnected)
        @ip_list  = payload[:ip_list]
        @hostname = payload[:hostname]
        @port     = payload[:port]
        @client   = payload[:client].dup || {}
        @services = payload[:services]
        @raw_info = payload

        new_seq = payload[:seq] || 1

        @seq = new_seq if new_seq > @seq || is_reconnected
      end

      def update_local_info(cpu_usage); end

      ##
      # Update heartbeat properties
      #
      # @param payload [Hash] heartbeat payload
      def heartbeat(payload)
        unless @available
          @available     = true
          @offline_since = nil
        end

        @cpu     = payload[:cpu]
        @cpu_seq = payload[:cpu_seq]

        @last_heartbeat_time = Time.now
      end

      ##
      # Node disconnected
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
