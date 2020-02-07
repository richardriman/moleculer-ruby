# frozen_string_literal: true

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
      # Registers all associated services for the given node.
      #
      # @param node [Moleculer::Node] the node to register
      # @param is_update [Boolean] whether or not the registration is to be treated as an update to an existing nod
      def register_services_for_node(node, is_update)
        if is_update
          @services = ::Hash[@services.map do |name, services|
            services.delete_if { |s| s.node.id == node.id }
            [name, services]
          end]
        end

        node.services.values.each { |s| add(s) }
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

      def inspect
        "#<#{self.class.name}:#{'0x%x' % __id__}>"
      end

      private

      def remove_duplicates(service)
        @services[service.name].delete_if { |s| s.node.id == service.node.id && service != s }
      end
    end
  end
end
