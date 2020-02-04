# frozen_string_literal: true

RSpec.describe Moleculer::Service::Action do
  let(:broker)  { double(Moleculer::Broker::Base, call: true) }
  let(:service) { double(Moleculer::Service::Base, name: "test-service", broker: broker, test_action: true) }

  subject { Moleculer::Service::Action.new(service, "test_action", :test_action, {}) }

  describe "#call" do
    context "local call" do
      let(:context) { double(Moleculer::Context, local: true) }

      it "calls the method assigned to the action on the service" do
        subject.call(context, {})
        expect(service).to have_received(:test_action).with(context)
      end
    end

    context "remote call" do
      let(:context) { double(Moleculer::Context, local: false, params: { foo: "bar" }) }

      it "calls out to the broker" do
        subject.call(context, {})
        expect(broker).to have_received(:call).with("test-service.test_action", { foo: "bar" }, {})
      end
    end
  end
end
