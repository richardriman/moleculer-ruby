# frozen_string_literal: true

module Moleculer
  module Packets
    ##
    # Base packet class
    class Base
      attr_reader :payload
      attr_writer :target

      def self.type
        name.split("::")[-1]
      end

      def initialize(payload = {})
        @payload = payload.merge(ver: Moleculer::PROTOCOL_VERSION)
      end

      def type
        self.class.name
      end

      def as_json
        @payload
      end
    end
  end
end
