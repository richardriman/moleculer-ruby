RSpec.describe Moleculer::Broker::LocalEventBus do
  subject { Moleculer::Broker::LocalEventBus.new }

  describe "event flow" do
    it "allows you to subscribe to and broadcast events" do
      subject.on("fired") do |status|
        @fired = status
      end
      subject.broadcast("fired", "fired")
      until @fired
        sleep 0.1
      end
      expect(@fired).to eq("fired")
    end
  end
end
