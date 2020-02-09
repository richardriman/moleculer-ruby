# frozen_string_literal: true

module Moleculer
  ##
  # Node class
  class Node
    attr_reader :local, :ip_list, :hostname, :client, :seq, :id, :services

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
