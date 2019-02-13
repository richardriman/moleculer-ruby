# frozen_string_literal: true

require "uri"
require "logger"


require_relative "./packets"
require_relative "./transporters"
require_relative "./version"

module Moleculer
  # The Broker is the main component of Moleculer. It handles services, calls actions, emits events and
  # communicates with remote nodes.
  class Broker
    PROTOCOL_VERSION = "3"

    attr_reader :node_id, :transporter, :logger, :namespace, :services

    def initialize(options)
      @namespace   = options[:namespace]
      @logger      = Logger.new(STDOUT)
      @node_id     = options[:node_id]
      @transporter = Transporters.for(options[:transporter]).new(self, options[:transporter])
    end

    # Starts the broker.
    def start
      logger.info "Moleculer Ruby #{Moleculer::VERSION}"
      logger.info "Node ID: #{node_id}"
      logger.info "Transporter: #{transporter.name}"
      transporter.connect
      subscribe_to_all_events
    end

    def run
      start
      transporter.join
    end

    private

    def broadcast_discover
      logger.info "Send #{Packets::Discover::NAME} to '<all nodes>'"
      transporter.broadcast(Packets::Discover.new(node_id: node_id, namespace: namespace, data: {
        ver:    PROTOCOL_VERSION,
        sender: node_id
      }))
    end

    def subscribe_to_all_events
      subscribe_to_disconnect
      subscribe_to_discover
      subscribe_to_events
      subscribe_to_info
      subscribe_to_ping
      subscribe_to_pong
      subscribe_to_requests
      subscribe_to_responses
      subscribe_to_targeted_discover
      subscribe_to_targeted_info
      subscribe_to_targeted_ping
    end

    def subscribe_to_balanced_events(event)
      logger.debug "setting up balanced event subscription for '#{event}'"
      transporter.subscribe("MOL.EVENTB.#{event}", Packets::Event) do

      end
    end


    def subscribe_to_balanced_requests(action)
      logger.debug "setting up balanced requests subscription for action '#{action}'"
      transporter.subscribe("MOL.REQ.#{action}", Packets::Request) do

      end
    end

    def subscribe_to_disconnect
      logger.debug "setting up ping subscription"
      transporter.subscribe("MOL.DISCONNECT", Packets::Disconnect) do

      end
    end


    def subscribe_to_discover
      logger.debug "setting up discover subscription"
      transporter.subscribe("MOL.DISCOVER", Packets::Discover) do

      end
    end


    def subscribe_to_events
      logger.debug "setting up event subscription"
      transporter.subscribe("MOL.EVENT.#{node_id}", Packets::Event) do

      end
    end

    def subscribe_to_info
      logger.debug "setting up info subscription"
      transporter.subscribe("MOL.INFO", Packets::Info) do

      end
    end

    def subscribe_to_ping
      logger.debug "setting up ping subscription"
      transporter.subscribe("MOL.PING", Packets::Ping) do

      end
    end

    def subscribe_to_pong
      logger.debug "setting up pong subscription"
      transporter.subscribe("MOL.PONG", Packets::Pong) do

      end
    end

    def subscribe_to_requests
      logger.debug "setting up requests subscription"
      transporter.subscribe("MOL.REQ.#{node_id}", Packets::Request) do

      end
    end

    def subscribe_to_responses
      logger.debug "setting up responses subscription"
      transporter.subscribe("MOL.RES.#{node_id}", Packets::Response) do

      end
    end

    def subscribe_to_targeted_discover
      logger.debug "setting up targeted discover subscription"
      transporter.subscribe("MOL.DISCOVER.#{node_id}", Packets::Discover) do

      end
    end


    def subscribe_to_targeted_ping
      logger.debug "setting up targeted ping subscription"
      transporter.subscribe("MOL.PING.#{node_id}", Packets::Ping) do

      end
    end


    def subscribe_to_targeted_info
      logger.debug "setting up targeted info subscription"
      transporter.subscribe("MOL.INFO.#{node_id}", Packets::Info) do

      end
    end

  end
end



