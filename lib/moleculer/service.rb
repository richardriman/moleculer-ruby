# frozen_string_literal: true

require_relative "service/base"


module Moleculer
  module Service
    def self.from_schema(schema)
      Class.new(Moleculer::Service::Base) do
        service_name(schema["name"])

        schema["actions"].each do |name, options|
          method_name = SecureRandom.hex(5)
          action(name, "action_#{method_name}", options)
          define_method "action_#{method_name}" do |ctx|
            @broker.call(name, ctx.params)
          end

          schema["events"].each do |name, options|
            event(name, :__remote__, options)
          end
        end
      end
    end
  end
end
