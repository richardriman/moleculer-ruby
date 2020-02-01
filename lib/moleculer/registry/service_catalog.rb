module Moleculer
  module Registry
    ##
    # Catalog for services
    class ServiceCatalog
      def initialize(registry)
        @registry = registry
        @broker   = @registry.broker
        @logger   = @registry.logger

        @services = {}
      end


    end
  end
end
