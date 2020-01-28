# frozen_string_literal: true

require_relative "../../lib/moleculer/serializers/json"

RSpec.describe Moleculer::Serializers do
  describe "::resolve" do
    it "resolves the provided serializer and returns the serializer instance" do
      expect(described_class.resolve("Json")).to eq(Moleculer::Serializers::Json)
    end
  end
end
