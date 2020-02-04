# frozen_string_literal: true

RSpec.describe Moleculer::Node do
  let(:service) do
    Class.new(Moleculer::Service::Base) do
      service_name "local-service"

      action "local-action", :local_action
    end
  end

  subject do
    Moleculer::Node.new(Moleculer::Broker.new,
                        id:       "local-node",
                        services: [service],
                        ip_list:  Moleculer::Utils.get_ip_list,
                        client:   {
                          type:         "ruby",
                          version:      Moleculer::VERSION,
                          lang_version: RUBY_VERSION,
                        })
  end

  describe "#schema" do
    it "generates a valid schema" do
      expect(subject.schema).to include(
        ip_list:  Moleculer::Utils.get_ip_list,
        client:   {
          type:         "ruby",
          version:      Moleculer::VERSION,
          lang_version: RUBY_VERSION,
        },
        seq:      0,
        services: array_including(
          hash_including(
            name: "local-service",
          ),
        ),
      )
    end
  end
end
