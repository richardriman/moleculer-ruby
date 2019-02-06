require_relative "./base"

module Moleculer
  module Packets
    class Discover < Base
      NAME = "DISCOVER"

      field :ver
      field :sender

    end
  end
end
