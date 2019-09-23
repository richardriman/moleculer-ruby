# frozen_string_literal: true

RSpec.shared_examples "subscription" do |packet|
  it "should subscribe to #{packet}" do
    subject.send(:"subscribe_to_#{packet.downcase}")
    expect(transporter).to have_received(:subscribe).at_least(1).times.with("MOL.#{packet.upcase}")
  end
end
