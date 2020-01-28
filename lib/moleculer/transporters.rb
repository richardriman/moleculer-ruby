# frozen_string_literal: true

module Moleculer
  ##
  # Encapsultates transporters
  module Transporters
    extend self

    ##
    # Resolve the transporter configuration to the correct transporter
    def resolve(transporter)
      trans = %r{^([a-z]+)(:\/\/.+)?$}.match(transporter)[1]
      require_relative("transporters/#{Utils::String.underscore(trans)}")
      const_get(trans.capitalize.to_sym)
    end
  end
end
