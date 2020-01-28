# frozen_string_literal: true

require_relative "../../../lib/moleculer/serializers/json"
require_relative "../../../lib/moleculer/transit"
require_relative "../../../lib/moleculer/packet"

RSpec.describe Moleculer::Serializers::JSON do
  let(:broker) { double(Moleculer::Broker) }
  let(:transit) { double(Moleculer::Transit, broker: broker) }

  subject { Moleculer::Serializers::JSON.new(transit) }

  describe "#serialize" do
    it "serializes the message to JSON" do
      expect(subject.serialize(Moleculer::Packet::INFO, test_one: "test")).to eq("{\"testOne\":\"test\"}")
    end

    it "deserializes message from json" do
      expect(subject.deserialize(Moleculer::Packet::INFO,"{\"testOne\":\"test\"}")).to eq(test_one: "test")
    end
  end
end
