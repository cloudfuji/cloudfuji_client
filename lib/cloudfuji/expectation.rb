module Cloudfuji
  class Expectation
    class << self
      def expectations_url
        "#{Cloudfuji::Platform.host}/apps/#{Cloudfuji::Platform.name}/expectations.json"
      end
      
      def create!(options={})
        # Enforce standard format on client side so that any errors
        # can be more quickly caught for the developer
        return StandardError("Cloudfuji::Event format incorrect, please make sure you're using the correct structure for sending events") unless !options[:criteria].nil? && !options[:expires_at].nil? && !options[:event].nil?
        return StandardError("Cloudfuji::Event format incorrect, please make sure you're using the correct structure for sending events") unless !options[:event][:category].nil? && !options[:event][:name].nil? && !options[:event][:data].nil?

        expectation                   = {}
        expectation[:criteria]        = options[:criteria]
        expectation[:expires_at]      = options[:expires_at]
        expectation[:event]           = options[:event]
        expectation[:parent_event_id] = options[:parent_event_id]

        payload = {:expectation => expectation}

        Cloudfuji::Command.post_command(expectations_url, payload)
      end

    end
  end
end
