# frozen_string_literal: true

require_relative "../spec_helper"
require_relative "local_service"
require_relative "remote_service"

module IntegrationHelpers
  def remote
    @remote
  end

  def local
    @local
  end

  alias broker local

  def create_broker(node_id, transporter, serializer, *services)
     Moleculer::Broker.new(
        node_id:     node_id,
        services:    services,
        transporter: transporter,
        log_file:    STDOUT,
        log_level:   :debug,
        serializer:  serializer,
    )
  end
end

RSpec.configure do |c|
  c.include IntegrationHelpers
end
