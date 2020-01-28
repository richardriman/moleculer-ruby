# frozen_string_literal: true

require "active_support/tagged_logging"

require_relative "default_options"
require_relative "utils"
require_relative "../logger"

module Moleculer
  module Broker
    ##
    # Service Broker class
    class Base
      include DefaultOptions
      include Logger

      def initialize(options = {})
        @options   = DEFAULT_OPTIONS.merge(options)
        @started   = false
        @namespace = @options[:namespace]
        @node_id   = @options[:node_id] || Utils.get_node_id
        @logger    = get_logger("BROKER")
      end
    end
  end
end
