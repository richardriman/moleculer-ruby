# frozen_string_literal: true

require_relative "default_options"
require_relative "../serializers"
require_relative "../logger"
require_relative "../transit"

module Moleculer
  module Broker
    ##
    # Service Broker class
    class Base
      include DefaultOptions
      include Logger

      attr_reader :namespace, :serializer, :options, :transporter, :node_id

      def initialize(options = {})
        @options     = DEFAULT_OPTIONS.merge(options)
        @started     = false
        @namespace   = @options[:namespace]
        @node_id     = @options[:node_id]
        @logger      = get_logger("BROKER")
        @serializer  = Serializers.resolve(@options[:serializer]).new(self)
        @transporter = Transporters.resolve(@options[:transporter])
        @transit     = Transit.new(self, @options[:transit])
      end

      def start
        @transit.connect
      end

      def stop
      end

      ##
      # Creates a service instance from a service class
      # @param [Service::Base] service_class the service class to instantiate
      def create_service(service_class)
        service_class.new(self)
      end

      def wait_for_services(*services)
        true
      end

      def get_logger(*tags)
        super(tags.unshift(@node_id))
      end

    end
  end
end
