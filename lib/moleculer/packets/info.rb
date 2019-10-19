require "socket"
require_relative "base"

module Moleculer
  module Packets
    ##
    # Represents an INFO packet
    class Info < Base
      include Support

      ##
      # Represents the client information for a given node
      class Client
        include Support

        # @!attribute [r] type
        #   @return [String] type of client implementation (nodejs, java, ruby etc.)
        # @!attribute [r] version
        #   @return [String] the version of the moleculer client
        # @!attribute [r] lang_version
        #   @return [String] the client type version
        attr_reader :type,
                    :version,
                    :lang_version

        def initialize(data)
          @type         = HashUtil.fetch(data, :type, nil)
          @version      = HashUtil.fetch(data, :version, nil)
          @lang_version = HashUtil.fetch(data, :lang_version, nil)
        end

        ##
        # @return [Hash] the object prepared for conversion to JSON for transmission
        def to_h
          {
            type:        @type,
            version:     @version,
            langVersion: @lang_version,
          }
        end
      end

      packet_attr :services
      packet_attr :config
      packet_attr :ip_list
      packet_attr :hostname
      packet_attr :client

      def topic
        return "#{super}.#{@config.node_id}" if @config.node_id

        super
      end

      def to_h
        super.merge(
          services: services,
          config:   config_for_hash,
          ipList:   ip_list,
          hostname: hostname,
          client:   client.to_h,
        )
      end

      private

      def config_for_hash
        Hash[config.to_h.reject { |a, _| a == :log_file }]
      end
    end
  end
end
