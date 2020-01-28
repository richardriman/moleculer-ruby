# frozen_string_literal: true

require_relative "base"

module Moleculer
  module Serializers
    ##
    # JSON serializer
    class Json < Base
      def serialize(_type, message)
        Utils::Hash.to_json(message)
      end

      def deserialize(_type, message)
        normalize(Utils::Hash.from_json(message))
      end
    end
  end
end
