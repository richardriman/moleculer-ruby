# frozen_string_literal: true

require_relative "../../../lib/moleculer/utils/string"

RSpec.describe Moleculer::Utils::String do
  describe "#camelize" do
    it { expect(described_class.camelize("totez_test_string")).to eq("totezTestString") }
  end

  describe "#underscore" do
    it { expect(described_class.underscore("stuffAndThings")).to eq("stuff_and_things") }
  end
end
