# frozen_string_literal: true

require_relative "../../../lib/moleculer/broker/utils"

RSpec.describe Moleculer::Broker::Utils do
  describe "::get_node_id" do
    it "should return a host based node id" do
      expect(subject.get_node_id).to eq("#{Socket.gethostname}-#{Process.pid}")
    end
  end
end
