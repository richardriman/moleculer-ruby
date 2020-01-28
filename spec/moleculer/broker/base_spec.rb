# frozen_string_literal: true

RSpec.describe Moleculer::Broker::Base do
  let(:service_class) do
    Class.new(Moleculer::Service::Base) do
    end
  end

  describe "#namespace" do
    subject { Moleculer::Broker::Base.new(namespace: "test") }

    it "returns the namespace option" do
      expect(subject.namespace).to eq("test")
    end
  end

  describe "#create_service" do
    it "instantiates and returns the instantiated service" do
      expect(subject.create_service(service_class)).to be_a(Moleculer::Service::Base)
    end
  end
end
