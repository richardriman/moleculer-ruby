# frozen_string_literal: true

RSpec.describe Moleculer::Registry::ServiceCatalog do
  let(:node_id) { "test" }
  let(:broker) { double(Moleculer::Broker::Base, node_id: node_id) }
  let(:registry) { double(Moleculer::Registry::Base, broker: broker, logger: true) }
  let(:node) { double(Moleculer::Registry::Node, id: node_id) }

  subject { Moleculer::Registry::ServiceCatalog.new(registry) }

  describe "#add" do
    context "local node" do
      it "adds the appropriate ServiceItem to the service list and returns the item" do
        item = subject.add(node, "test-service", "1", { foo: "bar" }, bar: "foo")
        expect(item.instance_variable_get(:@node)).to eq(node)
        expect(item.instance_variable_get(:@name)).to eq("test-service")
        expect(item.instance_variable_get(:@version)).to eq("1")
        expect(item.instance_variable_get(:@settings)).to include(foo: "bar")
        expect(item.instance_variable_get(:@metadata)).to include(bar: "foo")
        expect(item.instance_variable_get(:@local)).to be_truthy
        expect(subject.instance_variable_get(:@services).last).to eq(item)
      end
    end

    context "remote node" do
      it "sets local to false" do
        item = subject.add(
          double(Moleculer::Registry::Node, id: "remote"),
          "test-service",
          "1",
          { foo: "bar" },
          bar: "foo",
        )
        expect(item.instance_variable_get(:@local)).to be_falsey
      end
    end
  end

  describe "#has" do
    before :each do
      subject.add(node, "test1", "1", {}, {})
      subject.add(node, "test2", "2", {}, {})
      subject.add(double(Moleculer::Registry::Node, id: "remote"), "test", "3", {}, {})
    end

    it "returns true when the service was found" do
      expect(subject.has("test1", "1", node_id)).to be_truthy
    end

    it "returns false when the service was not found" do
      expect(subject.has("test99", "1", node_id)).to be_falsey
      expect(subject.has("test1", "2", node_id)).to be_falsey
      expect(subject.has("test1", "1", "remote")).to be_falsey
    end
  end
end
