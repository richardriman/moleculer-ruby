require_relative "../../../lib/moleculer/transporters/base"
require_relative "../../../lib/moleculer/serializers/json"


RSpec.describe Moleculer::Transporters::Base do
  let(:logger) { Logger.new("/dev/null") }
  let(:transit) { double(Moleculer::Transit, broker: broker) }
  let(:serializer) { double(Moleculer::Serializers::Json, serialize: true) }
  let(:broker) { double(Moleculer::Broker, serializer: serializer, node_id: "test", transporter: true, get_logger: logger , namespace: "") }
  let(:packet) { double(Moleculer::Packets::Base, as_json: { json: "yes!" }, payload: {}) }

  subject { described_class.new(broker) }

  describe "#transit=" do
    it "allows the setting of the transit attribute" do
      subject.transit = transit
      expect(subject.instance_variable_get(:@transit)).to eq(transit)
    end
  end

end
