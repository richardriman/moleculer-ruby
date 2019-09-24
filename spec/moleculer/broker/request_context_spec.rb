# frozen_string_literal: true

RSpec.describe Moleculer::Broker::RequestContext do
  let(:action) { double(Moleculer::Service::Action, execute: true) }
  let(:broker) { double(Moleculer::Broker) }
  subject do
    Moleculer::Broker::RequestContext.new(
      broker:  broker,
      action:  action,
      params:  {},
      meta:    {},
      timeout: 1,
    )
  end

  describe "#created_at" do
    before :each do
      Timecop.freeze
    end

    after :each do
      Timecop.return
    end

    it "sets the time" do
      expect(subject.created_at).to eq(Time.now)
    end
  end

  describe "#id" do
    it "sets the id" do
      expect(subject.id).to eq("test")
    end
  end

  describe "#call" do
    it "calls the future with the provided args" do
      subject.call
      expect(action).to have_received(:execute).with(subject, broker)
    end
  end
end
