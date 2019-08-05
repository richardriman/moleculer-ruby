require_relative "action"
require_relative "event"

module Moleculer
  module Service
    ##
    # @abstract subclass to define a local service.
    class Base
      class << self
        # @!attribute [rw] service_prefix
        #   @return [string] a prefix to add to the service name. The service_prefix is inherited from the parent class
        #           if it is not already defined in the current class.
        attr_writer :service_prefix

        ##
        # The broker this service is attached to
        attr_writer :broker

        def service_prefix
          Moleculer.service_prefix
        end

        def node
          broker.local_node
        end

        def broker
          @broker || Moleculer.broker
        end

        ##
        # Set the service_name to the provided name. If the node is local it will prefix the service name with the
        # service prefix
        #
        # @param name [String] the name to which the service_name should be set
        def service_name(name = nil)
          @service_name = name if name

          return "#{broker.service_prefix}.#{@service_name}" unless broker.service_prefix.nil?

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
          actions[action_name_for(name)] = Action.new(name, self, method, options)
        end

        ##
        # Defines an event on the service.
        #
        # @param name [String|Symbol] the name of the event.
        # @param method [Symbol] the method to which the event maps.
        # @param options [Hash] event options.
        # @option options [Hash] :group the group in which the event should belong, defaults to the service_name
        def event(name, method, options = {})
          events[name] = Event.new(name, self, method, options)
        end

        def actions
          @actions ||= {}
        end

        def events
          @events ||= {}
        end

        def action_name_for(name)
          "#{service_name}.#{name}"
        end
      end

      def initialize(broker)
        @broker = broker
      end

      ##
      # returns the action defined on the service class
      # @see action
      def actions
        self.class.actions
      end

      ##
      # returns the events defined on the service class
      # @see events
      def events
        self.class.events
      end

      ##
      # @return [Moleculer::Broker] the moleculer broker the service is attached to
      def broker
        self.class.broker
      end

      def self.as_json
        {
          name:     service_name,
          settings: {},
          metadata: {},
          actions:  Hash[actions.values.map { |a| [a.name.to_sym, a.to_h] }],
          events:   Hash[events.values.map { |e| [e.name.to_sym, e.to_h] }],
        }
      end
    end
  end
end
