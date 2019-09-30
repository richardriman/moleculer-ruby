# frozen_string_literal: true

require_relative "local_service"
require_relative "remote_service"

RSpec.describe "request response cycle" do
  let(:broker) do
    broker = Moleculer::Broker.new(
      Moleculer::Configuration.new(
        node_id:     "local-node",
        services:    [LocalService],
        transporter: "fake://localhost",
        log_level: "trace",
        log_file: STDOUT
      ),
    )

  end

  let(:remote_broker) do
    broker = Moleculer::Broker.new(
      Moleculer::Configuration.new(
        node_id:     "remote-node",
        services:    [RemoteService],
        transporter: "fake://localhost",
        log_level: "trace",
        log_file: STDOUT
      ),
    )

  end

  before :each do
    broker.start
    remote_broker.start
    sleep 0.5
  end

  after :each do
    broker.stop
    remote_broker.stop
  end


  describe "actions" do
    it "returns the correct value for an action" do
      expect(broker.call("local.test_action", {})[:response]).to eq(4)
    end

    it "return the correct value for a remote action" do
      expect(broker.call("remote.test_action", {})[:response]).to eq(4)
    end
  end
end
