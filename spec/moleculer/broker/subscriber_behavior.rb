# frozen_string_literal: true

RSpec.shared_examples "subscription" do |packet|
  it "should subscribe to #{packet}" do
    subject.send(:"subscribe_to_#{packet.downcase}")
    expect(transporter).to have_received(:subscribe).with("MOL.#{packet.upcase}")
  end
end
