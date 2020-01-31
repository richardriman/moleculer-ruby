module Moleculer
  class Registry
    def initialize(broker)
      @broker = broker
      @logger = @broker.get_logger("registry")
      @options = (@broker.options[:registry] || {}).dup

    end
  end
end
