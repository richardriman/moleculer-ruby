# frozen_string_literal: true

require_relative "service_item"

module Moleculer
  module Registry
    ##
    # Catalog for services
    class ServiceCatalog
      ##
      # @param registry [Moleculer:Registry]
      def initialize(registry)
        @registry = registry
        @broker   = @registry.broker
        @logger   = @registry.logger

        @services = []
      end

      ##
      # Add a new service
      # @param node [Moleculer::Registry::Node]
      # @param name [String]
      # @param settings [::Hash]
      # @param metadata [::Hash]
      #
      # @return [ServiceItem]
      def add(node, name, version, settings, metadata)
        item = ServiceItem.new(node, name, version, settings, metadata, node.id == @broker.node_id)
        @services.push(item)
        item
      end

      ##
      # Checks if the given service exists
      #
      # @param name [String]
      # @param version [String]
      # @param node_id [String]
      def has(name, version, node_id)
        !@services.select { |svc| svc.equals?(name, version ,node_id) }.empty?
      end
    end
  end
end
