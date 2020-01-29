# frozen_string_literal: true

module Moleculer
  ##
  # Encapsultates transporters
  module Transporters
    extend self

    ##
    # Resolve the transporter configuration to the correct transporter
    def resolve(transporter)
      if transporter.is_a?(String)
        trans = %r{^([a-z]+)(:\/\/.+)?$}.match(transporter)[1]
      else
        if (transporter[:url])
          trans = %r{^([a-z]+)(:\/\/.+)?$}.match(transporter[:url])[1]
        end
        require_relative("transporters/#{Utils::String.underscore(trans)}")
        const_get(trans.capitalize.to_sym)
      end
    end
  end
end
