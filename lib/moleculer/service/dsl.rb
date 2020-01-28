# frozen_string_literal: true

require_relative "action"
require_relative "event"

module Moleculer
  module Service
    ##
    # DSL Functions for services
    # @private
    module DSL
      def self.included(base)
        base.extend ClassMethods
      end

      # @private
      module ClassMethods
        ##
        # Set the service_name to the provided name.
        #
        # @param name [String] the name to which the service_name should be set
        def service_name(name = nil)
          @service_name = name if name
          @service_name
        end

        ##
        # Defines an action on the service.
        #
        # @param name [String|Symbol] the name of the action.
        # @param method [Symbol] the method to which the action maps.
        # @param options [Hash] the action options.
        # @option options [Boolean|Hash] :cache if true, will use default caching options, if a hash is provided caching
        # options will reflect the hash.
        # @option options [Hash] params list of param and param types. Can be used to coerce specific params to the
        # provided type.
        def action(name, method, options = {})
          actions[name] = Action.new(name, method, options)
        end

        ##
        # Defines an event on the service.
        #
        # @param name [String|Symbol] the name of the event.
        # @param method [Symbol] the method to which the event maps.
        # @param options [Hash] event options.
        # @option options [Hash] :group the group in which the event should belong, defaults to the service_name
        def event(name, method, options = {})
          events[name] = Event.new(name, method, options)
        end

        ##
        # Defines a version name or number on the service.
        #
        # @param ver [String|Number] the version of the service.
        def version(ver = nil)
          @version = ver if ver
          @version
        end

        def actions
          @actions ||= {}
        end

        def events
          @events ||= {}
        end
      end
    end
  end
end
