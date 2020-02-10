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

      attr_reader :namespace, :serializer, :options, :transporter, :node_id, :local_bus, :services, :registry, :transit

      def initialize(options = {})
        @options     = DEFAULT_OPTIONS.merge(options)
        @started     = false
        @node_id     = @options[:node_id]
        @services    = @options[:services]
        @local_bus   = LocalEventBus.new
        @logger      = get_logger("BROKER")
        @serializer  = resolve_serializer(@options[:serializer])
        @registry    = Registry.new(self)
        @transporter = resolve_transporter(@options[:transporter])
        @transit     = Transit.new(self, @options[:transit])
      end

      def start
        @transit.connect
      end

      def stop; end

      def wait_for_services(*_services)
        true
      end

      def get_logger(*tags)
        super(tags.unshift(@node_id))
      end

      private

      def resolve_transporter(transporter)
        Transporters.resolve(transporter)
      end

      def resolve_serializer(serializer)
        Serializers.resolve(serializer).new(self)
      end
    end
  end
end
