require_relative "./base"

module Moleculer
  module Packets
    class  Disconnect < Base
      field :ver
      field :sender
    end
  end
end
