# frozen_string_literal: true

class FakeSubscriptions
  def initialize
    @subscriptions = {}
  end

  def subscribe(name, block)
    @subscriptions[name] = block
  end

  def call(name, *args)
    @subscriptions[name].call(*args)
  end
end
