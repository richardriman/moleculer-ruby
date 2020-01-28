# frozen_string_literal: true

require "active_support/tagged_logging"

require_relative "default_options"
require_relative "utils"
require_relative "../logger"
require_relative "../transit"

module Moleculer
  module Broker
    ##
    # Service Broker class
    class Base
      include DefaultOptions
      include Logger

      attr_reader :namespace

      def initialize(options = {})
        @options   = DEFAULT_OPTIONS.merge(options)
        @started   = false
        @namespace = @options[:namespace]
        @node_id   = @options[:node_id] || Utils.get_node_id
        @logger    = get_logger("BROKER")
      end

      ##
      # Creates a service instance from a service class
      # @param [Service::Base] service_class the service class to instantiate
      def create_service(service_class)
        service_class.new(self)
      end

      ##
      # Starts the service broker
      def start
      end
    end
  end
end
