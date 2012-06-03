module Cloudfuji
  # Cloudfuji::Event lists all the events from the Cloudfuji server. All events
  # are hashes with the following keys:
  # * category
  # * name
  # * data
  # Data will hold the arbitrary data for the type of event signalled
  class Event
    attr_reader :category, :name, :data

    class << self
      def events_url
        "#{Cloudfuji::Platform.host}/apps/#{Cloudfuji::Platform.name}/events.json"
      end

      def event_url(event_ido_id)
        "#{Cloudfuji::Platform.host}/apps/#{Cloudfuji::Platform.name}/events/#{event_ido_id}.json"
      end
      
      # Find an event by its ido_id Be careful not to abuse this - an
      # app can be throttled if requesting too many events too
      # quickly, which will cause errors and a bad user experience for
      # the end user
      def find(event_ido_id)
        Cloudfuji::Command.get_command(event_url(event_ido_id))
      end

      def publish(options={})
        # Enforce standard format on client side so that any errors
        # can be more quickly caught for the developer
        return StandardError("Cloudfuji::Event format incorrect, please make sure you're using the correct structure for sending events") unless !options[:name].nil? && !options[:category].nil? && !options[:data].nil?

        payload            = {}
        payload[:category] = options[:category]
        payload[:name]     = options[:name]
        payload[:data]     = options[:data]

        Cloudfuji::Command.post_command(events_url, payload)
      end
    end

    def initialize(options={})
      @category = options["category"]
      @name     = options["name"]
      @data     = options["data"]
    end

  end
end
