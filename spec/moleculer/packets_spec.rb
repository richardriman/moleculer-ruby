# frozen_string_literal: true

RSpec.describe Moleculer::Packets do
  describe "resolve" do
    it "resolves the correct packet name" do
      expect(described_class.resolve("INFO")).to eq(described_class::INFO)
    end
  end
end
