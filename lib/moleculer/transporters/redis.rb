# frozen_string_literal: true

require "redis"
require "securerandom"

require_relative "base"

module Moleculer
  module Transporters
    ##
    # Redis transporter
    class Redis < Base
      class << self
        attr_writer :hi_redis

        def hi_redis
          @hi_redis ||= false
        end
      end

      def connect(reconnect = false)
        @sub = ::Redis.new(@options)
        @pub = ::Redis.new(@options)
        make_subscriptions
      end

      def make_subscriptions
        Thread.new do
          topic_names = @subscriptions.map { |topic| get_topic_name(topic[:type].type, topic[:node_id]) }
          @sub.subscribe(*topic_names) do |on|
            on.subscribe do |channel|
              @logger.debug("subscribed to #{channel}")
            end
            on.message do |topic, message|
              self << { topic: topic, message: message }.freeze
            end
          end
        end
      end
    end
  end
end
