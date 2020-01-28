# frozen_string_literal: true

require_relative "../../lib/moleculer/serializers/json"

RSpec.describe Moleculer::Transit do
  let(:serializer) { double(Moleculer::Serializers::Json, serialize: true) }
  let(:broker) { double(Moleculer::Broker, serializer: serializer, node_id: "test", transporter: true, get_logger: true) }
  let(:packet) { double(Moleculer::Packets::Base, as_json: { json: "yes!" }, payload: {}) }

  subject { described_class.new(broker) }

  describe "#serialize" do
    it "uses the serializer to serialize the packet from #as_josn" do
      expect(serializer).to receive(:serialize).with(packet.as_json)
      subject.serialize(packet)
      expect(packet.payload[:sender]).to eq(broker.node_id)
    end
  end
end
