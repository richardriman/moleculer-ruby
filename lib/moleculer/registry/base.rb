# frozen_string_literal: true

require_relative "node_catalog"

module Moleculer
  module Registry
    ##
    # Node registry
    class Base
      attr_reader :broker

      ##
      # @param broker [Moleculer::Broker] the moleculer service broker
      def initialize(broker)
        @broker       = broker
        @logger       = @broker.get_logger("registry")
        @options      = (@broker.options[:registry] || {}).dup
        @node_catalog = NodeCatalog.new(self)
      end
    end
  end
end
