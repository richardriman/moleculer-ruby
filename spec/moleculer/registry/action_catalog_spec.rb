# frozen_string_literal: true

RSpec.describe Moleculer::Registry::ActionCatalog do
  let(:broker) { Moleculer::Broker.new }
  let(:registry) { Moleculer::Registry::Base.new(broker) }
  let(:node) { Moleculer::Node.new(broker, id: "test_node") }
  let(:service) { Moleculer::Service::Base.new(broker, node) }
  let(:other_service) { Moleculer::Service::Base.new(broker, node) }

  subject { Moleculer::Registry::ActionCatalog.new(registry) }

  let(:handler) { Moleculer::Service::Action.new(service, "test_action", "test_action", {}) }
  let(:other_handler) { Moleculer::Service::Action.new(service, "other_test_action", "test_action", {}) }

  describe "#register_action" do
    let(:duplicate_handler) { Moleculer::Service::Action.new(service, "test_action", "test_action", {}) }

    it "adds the action to the handler list" do
      subject.register_action(handler)
      expect(subject.instance_variable_get(:@actions)[handler.name]).to include(handler)
    end

    it "removes duplicate handlers from the same node" do
      subject.register_action(handler)
      subject.register_action(duplicate_handler)
      expect(subject.instance_variable_get(:@actions)[duplicate_handler.name]).to include(duplicate_handler)
      expect(subject.instance_variable_get(:@actions)[handler.name]).to_not include(handler)
    end
  end

  describe "#register_actions" do
    it "adds all of the provided actions to the catalog" do
      subject.register_actions([handler, other_handler])
      expect(subject.instance_variable_get(:@actions).values.flatten).to include(handler, other_handler)
    end
  end

  describe "#register_actions_for_node" do
    let(:test_service_handler) { Moleculer::Service::Action.new(service, "test-service-handler", nil, {}) }
    let(:service) do
      Class.new(Moleculer::Service::Base) do
        service_name "test-service"
      end
    end

    let(:other_test_service_handler) { Moleculer::Service::Action.new(service, "other-test-service-handler", nil, {}) }
    let(:other_service) do
      Class.new(Moleculer::Service::Base) do
        service_name "other-test-service"
      end
    end

    let(:node) { Moleculer::Node.new(broker, services: [service, other_service])}

    before :each do
      allow(node.services[service.service_name]).to receive(:actions)
                                                        .and_return("test-service-handler": test_service_handler)
      allow(node.services[other_service.service_name]).to receive(:actions)
                                                              .and_return("other-test-service-handler": other_test_service_handler)
    end

    it "registers all actions of the node" do
      expect(subject).to receive(:register_actions).with([test_service_handler, other_test_service_handler])
      subject.register_actions_for_node(node, false)
    end
  end
end
