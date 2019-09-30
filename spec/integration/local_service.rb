# frozen_string_literal: true

require_relative "../../lib/moleculer/service/base"

class LocalService < Moleculer::Service::Base
  service_name "local"
  action :test_action, :test_action

  def test_action(_)
    { response: 2 + 2 }
  end
end
