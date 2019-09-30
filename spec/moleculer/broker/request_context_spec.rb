# frozen_string_literal: true

RSpec.describe Moleculer::Broker::RequestContext do
  let(:action) { double(Moleculer::Service::Action, execute: true) }
  let(:broker) { double(Moleculer::Broker) }
  subject do
    Moleculer::Broker::RequestContext.new(
      id:        "test",
      broker:    broker,
      action:    action,
      params:    {},
      meta:      {},
      timeout:   1,
      parent_id: "test",
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

  describe "#action" do
    it "returns the action" do
      expect(subject.action).to eq(action)
    end
  end

  describe "#params" do
    it "returns the params" do
      expect(subject.params).to eq({})
    end
  end

  describe "#parent_id" do
    it "returns the params" do
      expect(subject.parent_id).to eq("test")
    end
  end

  describe "#parent_id" do
    it "returns the params" do
      expect(subject.parent_id).to eq("test")
    end
  end

  describe "#request_id" do
    it "returns the params" do
      expect(subject.request_id).to eq(subject.instance_variable_get(:"@request_id"))
    end
  end

  describe "#timeout" do
    it "returns the params" do
      expect(subject.timeout).to eq(1)
    end
  end

  describe "#meta" do
    it "returns the params" do
      expect(subject.meta).to eq({})
    end
  end

  describe "#call" do
    it "calls the future with the provided args" do
      subject.call
      expect(action).to have_received(:execute).with(subject, broker)
    end
  end
end
