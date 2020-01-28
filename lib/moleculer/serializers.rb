# frozen_string_literal: true

require_relative "utils/string"
require_relative "serializers/base"

module Moleculer
  ##
  # Encapsulates the Moleculer serializers
  module Serializers
    extend self

    ##
    # Resolves the serializer configuration value into the serializer instance
    def resolve(serializer)
      require_relative("serializers/#{Utils::String.underscore(serializer)}")
      const_get(serializer.to_sym)
    end
  end
end
