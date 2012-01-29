module Bushido
  # Bushido::Event lists all the events from the Bushido server. All events
  # are hashes with the following keys:
  # * category
  # * name
  # * data
  # Data will hold the arbitrary data for the type of event signalled
  class Event
    begin
      @@events = JSON.parse(ENV["BUSHIDO_EVENTS"]) #:nodoc:
    rescue
      @@events = []
    end

    attr_reader :category, :name, :data

    class << self
      def events_url
        "#{Bushido::Platform.host}/apps/#{Bushido::Platform.name}/events.json"
      end
      
      # Lists all events
      def all
        @@events.collect{ |e| Event.new(e) }
      end

      # Lists the first (oldest) event
      def first
        Event.new(@@events.first)
      end

      # Lists the last (newest) event
      def last
        Event.new(@@events.last)
      end

      # NOOP right now
      def refresh
        @@events = Bushido::Command.get_command(events_url)
      end

      def publish(options={})
        # Enforce standard format on client side so that any errors
        # can be more quickly caught for the developer
        return StandardError("Bushido::Event format incorrect, please make sure you're using the correct structure for sending events") unless !options[:name].nil? && !options[:category].nil? && !options[:data].nil?

        payload            = {}
        payload[:category] = options[:category]
        payload[:name]     = options[:name]
        payload[:data]     = options[:data]

        Bushido::Command.post_command(events_url, payload)
      end
    end

    def initialize(options={})
      @category = options["category"]
      @name     = options["name"]
      @data     = options["data"]
    end

  end
end
