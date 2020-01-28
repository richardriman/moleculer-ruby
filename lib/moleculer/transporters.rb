module Moleculer
  module Transports
    extend self

    ##
    # Resolve the transporter configuration to the correct transporter
    def resolve(transporter)
      require_relative("tansporters/#{Utils::String.underscore(transporter)}")
      const_get(transporter.to_sym)
    end
  end
end
