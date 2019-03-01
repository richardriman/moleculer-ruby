require "active_support/core_ext/hash/indifferent_access"

require "concurrent"

require "moleculer/version"
require "moleculer/broker"
require "moleculer/service"

module Moleculer
  PROTOCOL_VERSION = "3"
  class << self
    attr_writer :namespace, :node_id, :transporter

    def configure(&block)
      yield self
    end

    def broker
      @broker ||= Broker.new(node_id: self.node_id, transporter: self.transporter, namespace: self.namespace)
    end

    def call(action_name, params, options={}, &block)
      broker.call(action_name, params, options, &block)
    end

    def emit(event_name, payload)
      broker.emit(event_name, payload)
    end

    def start
      broker.start
    end

    def namespace
      @namespace || ""
    end

    def node_id
      @node_id || "#{Socket.gethostname.downcase}-#{Process.pid}"
    end

    def services
      @services ||= []
    end

    def timeout
      @timeout = 5
    end

    def transporter
      @transporter || "redis://localhost"
    end

    def register_service(klass)
      services << klass
    end

  end
end