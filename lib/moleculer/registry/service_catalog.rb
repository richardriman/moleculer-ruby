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
        @services = {}
      end

      ##
      # Adds the provided service to the catalog
      #
      # service @param [Moleculer::Service] the service to add to the catalog
      def add(service)
        @services[service.name] ||= []
        @services[service.name].push(service)
        remove_duplicates(service)
      end

      ##
      # @param name [String] the name of the service
      # @param version [String] the version of the service
      # @param node_id [String] the service node
      #
      # @return [Moleculer::Service] the service of the provided information
      def get(name, version, node_id)
        return nil unless @services[name]

        @services[name].select { |s| s.version == version && s.node.id == node_id }.first
      end

      ##
      # @param name [String] the name of the service
      # @param version [String] the version of the service
      # @param node_id [String] the service node
      #
      # @return [Boolean] whether or not the service of the given name exists in the catalog
      def has?(name, version, node_id)
        return false unless get(name, version, node_id)

        true
      end

      private

      def remove_duplicates(service)
        @services[service.name].delete_if { |s| s.node.id == service.node.id && service != s }
      end
    end
  end
end
