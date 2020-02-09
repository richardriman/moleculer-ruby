# frozen_string_literal: true

require_relative "../../../lib/moleculer/serializers/json"

RSpec.describe Moleculer::Broker::Base do

  describe "#transporter" do
    it "resolves and creates the transporter" do
      expect(subject.transporter).to be(Moleculer::Transporters::Redis)
    end
  end

  describe "#serializer" do
    it "sets the default serializer" do
      expect(subject.serializer).to be_a(Moleculer::Serializers::Json)
    end
  end

end
