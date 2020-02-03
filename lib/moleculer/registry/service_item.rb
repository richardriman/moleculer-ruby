module Moleculer
  module Registry
    ##
    # Represents a service in the service catalog
    class ServiceItem
      ##
      # @param node [Moleculer::Registry::Node]
      # @param name [String]
      # @param version [String]
      # @param settings [::Hash]
      # @param metadata [::Hash]
      # @param local [Boolean]
      def initialize(node, name, version, settings, metadata, local)
        @node = node
        @name = name
        @version = version
        @settings = settings
        @metadata = metadata || {}
        @local = local

        @actions = {}
        @events = {}
      end

      ##
      # Check if the service equals the params
      #
      # @param name [String]
      # @param version [String]
      # @param node_id [String]
      #
      # @return [Boolean] true if the service equals the provided params
      def equals?(name, version, node_id)
        @name == name && @version == version && @node.id == node_id
      end
    end
  end
end
