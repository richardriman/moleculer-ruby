# frozen_string_literal: true

require_relative "../../../lib/moleculer/utils/hash"

module Moleculer
  module Serializers
    ##
    # Base serializer
    class Base
      def initialize(broker)
        @broker = broker
      end

      def serialize(_type, _message)
        raise NotImplementedError
      end

      def deserialize(_type, _message)
        raise NotImplementedError
      end

      private

      def normalize(message)
        Utils::Hash.symbolize(message)
      end

      def serialize_custom_fields(type, message)
        case type
        when Packet::INFO
          return message.merge(serialize_custom_info_fields(message))
        end
      end

      def serialize_custom_info_fields(message)
        result = {
            services: message[:services].to_json
        }
        result[:config] = message[:config].to_json if message[:config]
        result
      end

      def serialize_custom_packet_fields(message)
        message[:data] = message[:data].to_json if message[:data]
      end

    end
  end
end
