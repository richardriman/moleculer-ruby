module Moleculer
  class Context
    attr_reader :context
    def initialize(options={})
      @local = options[:local]
    end
  end
end
