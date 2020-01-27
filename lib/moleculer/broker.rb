# frozen_string_literal: true

module Moleculer
  ##
  # Service broker class
  class Broker
    ##
    # Default broker options
    DEFAULT_OPTIONS = {
      namespace:           "",
      logFormatter:        "default",
      requestTimeout:      0 * 1000,

      retryPolicy:         {
        enabled:  false,
        retries:  5,
        delay:    100,
        maxDelay: 1000,
        factor:   2,
        # check: err => err && !!err.retryable
      },

      maxCallLevel:        0,
      heartbeatInterval:   5,
      heartbeatTimeout:    15,

      tracking:            {
        enabled:         false,
        shutdownTimeout: 5000,
      },

      disableBalancer:     false,

      registry:            {
        strategy:    "RoundRobin",
        preferLocal: true,
      },

      circuitBreaker:      {
        enabled:         false,
        threshold:       0.5,
        windowTime:      60,
        minRequestCount: 20,
        halfOpenTime:    10 * 1000,
        # check: err => err && err.code >= 500
      },

      bulkhead:            {
        enabled:      false,
        concurrency:  10,
        maxQueueSize: 100,
      },

      transit:             {
        # maxQueueSize: 50 * 1000, // 50k ~ 400MB,
        packetLogFilter:     [],
        disableReconnect:    false,
        disableVersionCheck: false,
      },

      validation:          true,
      metrics:             false,
      metricsRate:         1,
      internalServices:    true,
      internalMiddlewares: true,

      hotReload:           false,

    }.freeze

    def initialize(options)
    end
  end
end
