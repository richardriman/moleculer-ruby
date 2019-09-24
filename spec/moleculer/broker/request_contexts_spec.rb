# frozen_string_literal: true

RSpec.describe Moleculer::Broker::RequestContexts do
  let(:config) { double(Moleculer::Configuration, timeout: 1) }
  let(:broker) { double(Moleculer::Broker, config: config) }
  subject do
    Moleculer::Broker::RequestContexts.new(broker)
  end

  let(:contexts) { subject.instance_variable_get(:@contexts) }
  let(:context) { double(Moleculer::Broker::RequestContext, id: "test", broker: broker, created_at: Time.now) }

  describe "#<<" do
    it "adds the context to the context list" do
      subject << context
      expect(contexts[context.id]).to eq(context)
    end
  end

  describe "#pop" do
    it "removes and returns the context of the given id" do
      subject << context
      expect(subject.pop("test")).to eq(context)
      expect(contexts["test"]).to be_nil
    end
  end

  describe "context cleaning" do
    let(:config) { double(Moleculer::Configuration, timeout: 0.125) }

    it "cleans up the context based on the broker timeout" do
      subject << context
      Timecop.freeze(Date.today + 1)
      sleep 0.25 # give the timeer enough time to clean ou the stale contexts
      expect(contexts["test"]).to be_nil
    end
  end
end
