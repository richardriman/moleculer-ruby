# frozen_string_literal: true

RSpec.describe Moleculer::Registry::ServiceCatalog do
  let(:broker) { Moleculer::Broker.new }
  let(:registry) { Moleculer::Registry::Base.new(broker) }
  subject { Moleculer::Registry::ServiceCatalog.new(registry) }

  let(:service) do
    Class.new(Moleculer::Service::Base) do
      service_name "test-service"
    end.new(broker, registry.local_node)
  end

  describe "#add" do
    let(:dup_service) do
      Class.new(Moleculer::Service::Base) do
        service_name "test-service"
      end.new(broker, registry.local_node)
    end

    it "adds the provided service to the catalog" do
      subject.add(service)
      expect(subject.get(service.name, service.version, service.node.id)).to eq(service)
    end

    it "removes duplicate services (same node)" do
      subject.add(service)
      subject.add(dup_service)
      expect(subject.get(service.name, service.version, service.node.id)).to eq(dup_service)
    end
  end

  describe "#get" do
    it "returns nil if the given service does not exist" do
      expect(subject.get("test", "test", "test")).to be_nil
    end

    it "returns the service if the given service does not exist" do
      subject.add(service)
      expect(subject.get(service.name, service.version, service.node.id)).to eq(service)
    end
  end

  describe "has?" do
    it "returns false if the service does not match" do
      expect(subject.has?("test", "test", "test")).to be_falsey
    end

    it "returns true if the service does match" do
      subject.add(service)
      expect(subject.has?(service.name, service.version, service.node.id)).to be_truthy
    end
  end

  describe "#register_service_for_node" do
    context "is a new service" do
      let(:service) do
        Class.new(Moleculer::Service::Base) do
          service_name "test-service"
        end
      end

      let(:second_service) do
        Class.new(Moleculer::Service::Base) do
          service_name "other-test-service"
        end
      end

      let(:node) do
        Moleculer::Node.new(broker,
            id: "test-node",
            services: [service, second_service]
        )
      end

      it "registers each service in the provided node with the catalog" do
        expect(subject).to receive(:add).with(node.services.values[0])
        expect(subject).to receive(:add).with(node.services.values[1])
        subject.register_services_for_node(node, false)
      end
    end
  end
end
