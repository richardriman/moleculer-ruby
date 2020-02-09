# frozen_string_literal: true

require_relative "service/base"


module Moleculer
  module Service
    def self.from_schema(s)
      Class.new(Moleculer::Service::Base) do
        service_name s["name"]
      end
    end
  end
end
