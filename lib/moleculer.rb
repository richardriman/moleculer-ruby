require "concurrent"
require "securerandom"
require "socket"
require "ougai"

require "moleculer/broker"
require "moleculer/context"
require "moleculer/service"
require "moleculer/support"
require "moleculer/version"
require "moleculer/node"
require "moleculer/serializers"
require "moleculer/packets"

# Moleculer is a fast, modern and powerful microservices framework for originally written for [Node.js](). It helps you
# to build efficient, reliable & scalable services. Moleculer provides many features for building and managing your
# microservices.
module Moleculer
  extend self
  PROTOCOL_VERSION = "3".freeze

  attr_writer :node_id,
              :logger,
              :log_level,
              :log,
              :serializer,
              :timeout,
              :transporter,
              :service_prefix

  # @!attribute broker [r]
  #   @return [Moleculer::Broker] the moleculer broker instance


  def broker
    @broker ||= Broker.new
  end

  ##
  # Calls the given action. This method will block until the timeout is hit (default 5 seconds) or the action returns
  # a response
  #
  # @param action [Symbol] the name of the action to call
  # @param params [Hash] params to pass to the action
  # @param kwargs [Hash] call options (see Moleculer::Broker#call)
  #
  # @return [Hash] the request response
  def call(action, params = {}, **kwargs)
    broker.ensure_running
    if params.empty?
      return broker.call(action.to_s, kwargs)
    end
    broker.call(action.to_s, params, kwargs)
  end

  def config
    yield self
  end

  def start
    broker.start
  end

  def run
    broker.run
  end

  def stop
    broker.stop
  end

  def emit(event, data)
    broker.ensure_running
    broker.emit(event, data)
  end

  def heartbeat_interval
    @heartbeat_interval ||= 5
  end

  def node_id
    @node_id ? "#{@node_id}-#{Process.pid}" : "#{Socket.gethostname.downcase}-#{Process.pid}"
  end

  def services
    @services ||= []
  end

  def logger
    unless @logger
      @logger = Ougai::Logger.new(@log || STDOUT)
      @logger.formatter = Ougai::Formatters::Readable.new("MOL")
      @logger.level = @log_level || :trace
    end
    @logger
  end

  def service_prefix
    @service_prefix
  end

  def serializer
    @serializer ||= :json
  end

  def timeout
    @timeout = 5
  end

  def transporter
    @transporter || "redis://localhost"
  end

  def wait_for_services(*services)
    @broker.wait_for_services(*services)
  end
  #
  #     def register_service(klass)
  #       services << klass
  #     end
  #
  #   end
end
