# frozen_string_literal: true

RSpec.describe Moleculer::Service::DSL do
  subject do
    Class.new do
      include Moleculer::Service::DSL
      service_name "test"
      version "1.0"

      action :foo, :foo
      event :bar, :bar
    end
  end

  describe "::action" do
    it "creates an action instance" do
      expect(subject.actions[:foo]).to be_a(Moleculer::Service::Action)
    end
  end

  describe "::Event" do
    it "creates an action instance" do
      expect(subject.events[:bar]).to be_a(Moleculer::Service::Event)
    end
  end

  describe "::service_name" do
    it "sets the service name correctly" do
      expect(subject.service_name).to eq("test")
    end
  end

  describe "::version" do
    it "sets the version correctly" do
      expect(subject.version).to eq("1.0")
    end
  end
end
