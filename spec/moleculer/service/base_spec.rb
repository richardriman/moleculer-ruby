# frozen_string_literal: true

RSpec.describe Moleculer::Service::Base do
  let(:broker)  { double(Moleculer::Broker::Base, call: true) }
  let(:node)    { double(Moleculer::Node) }
  subject do
    Class.new(Moleculer::Service::Base) do
      service_name "test-service"

      action "test-action", :test_action
    end.new(broker, node)
  end

  describe "#schema" do
    it "should return the service schema" do
      expect(subject.schema).to include(
        name:     "test-service",
        settings: {},
        metadata: {},
        actions:  {
          "test-service.test-action": {
            cache:    false,
            params:   {},
            raw_name: "test-action",
            name:     "test-service.test-action",
            metrics:  {
              params: false,
              meta:   true,
            },
          },
        },
        events:   {},
      )
    end
  end
end
