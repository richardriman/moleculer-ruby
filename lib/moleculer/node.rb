# frozen_string_literal: true

module Moleculer
  ##
  # Node class
  class Node
    attr_reader :local,
                :ip_list,
                :hostname,
                :client,
                :seq,
                :id,
                :services,
                :last_heartbeat_time,
                :available


    def self.from_info_packet(broker, packet)
      options = packet.payload
      options.merge!(
        id:       options[:sender],
        services: options[:services].map { |service| Moleculer::Service.from_schema(service) },
      )
      new(broker, options)
    end

    ##
    # Creates an instance of Node
    #
    # @param options [Hash]
    def initialize(broker, options)
      @broker              = broker
      @id                  = options[:id]
      @available           = true
      @local               = options[:local]
      @last_heartbeat_time = Time.now
      @ip_list             = options[:ip_list]
      @hostname            = options[:hostname]
      @seq                 = options[:seq] || 0
      @client              = options[:client] || {}
      @config              = {}

      @services = instantiate_services(options[:services] || [])
    end

    def actions
      @services.values.collect(&:actions).reduce({}, :merge)
    end

    def events
      @services.values.collect(&:events).reduce({}, :merge)
    end

    def beat
      @last_heartbeat_time = Time.now
      @available           = true
      @offline_since       = nil
    end

    def disconnected(_unexpected)
      if @available
        @offline_since = Time.now
        @seq          += 1
      end

      @available = false
    end

    ##
    # @return [::Hash] the node schema
    def schema
      {
        ip_list:  @ip_list,
        hostname: @hostname,
        client:   @client,
        seq:      @seq,
        port:     @port,
        services: @services.values.map(&:schema),
      }
    end

    private

    def instantiate_services(services)
      Concurrent::Hash[(services || []).map { |s| [s.service_name, s.new(@broker, self)] }]
    end
  end
end
