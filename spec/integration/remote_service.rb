# frozen_string_literal: true

require_relative "../../lib/moleculer/service/base"

class RemoteService < Moleculer::Service::Base
  service_name "remote"
  action :test_action, :test_action

  def test_action(_)
    { response: 2 + 2 }
  end
end
