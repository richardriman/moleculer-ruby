# frozen_string_literal: true

require_relative "default_options"
require_relative "local_event_bus"
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

      attr_reader :namespace, :serializer, :options, :transporter, :node_id, :local_bus

      def initialize(options = {})
        @options     = DEFAULT_OPTIONS.merge(options)
        @started     = false
        @namespace   = @options[:namespace]
        @node_id     = @options[:node_id]
        @local_bus   = LocalEventBus.new
        @logger      = get_logger("BROKER")
        @serializer  = Serializers.resolve(@options[:serializer]).new(self)
        @transporter = Transporters.resolve(@options[:transporter])
        @transit     = Transit.new(self, @options[:transit])
        @registry    = Registry.new(self, create_local_node(options[:services]))
      end

      def start
        @transit.connect
      end

      def stop; end

      ##
      # Creates a service instance from a service class
      # @param [Service::Base] service_class the service class to instantiate
      def create_service(service_class)
        service_class.new(self)
      end

      def register_local_service(service)
        @registry.register_local_service(service)
      end

      def wait_for_services(*_services)
        true
      end

      def get_logger(*tags)
        super(tags.unshift(@node_id))
      end

      private

      def create_local_node(services)
        Node.new(
          id:       node_id,
          local:    true,
          ip_list:  Utils.get_ip_list,
          hostname: Socket.gethostname,
          seq:      1,
          client:   {
            language:     "ruby",
            version:      Moleculer::VERSION,
            lang_version: RUBY_VERSION,
          },
          services: services,
        )
      end
    end
  end
end
