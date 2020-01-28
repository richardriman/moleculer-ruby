# frozen_string_literal: true

require_relative "../../lib/moleculer/transporters/fake"

RSpec.describe Moleculer::Transit do
  let(:logger) { Logger.new("/dev/null") }
  let(:transporter) { double(Moleculer::Transporters::Fake, "transit=": true, connect: true) }
  let(:broker) { double(Moleculer::Broker, serializer: {}, node_id: "test", transporter: transporter, get_logger: logger) }

  subject { described_class.new(broker, {}) }
  describe "::new" do
    it "sets the transit value on the transporter" do
      instance = described_class.new(broker, {})
      expect(transporter).to have_received(:"transit=").with(instance)
    end
  end

  describe "#connect" do
    it "calls connect on the transporter" do
      subject.connect
      expect(transporter).to have_received(:connect)
    end
  end
end
