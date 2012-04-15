module Cloudfuji
  class Platform #:nodoc:
    class << self
      def name
        ENV['CLOUDFUJI_NAME']
      end

      def key
        ENV['CLOUDFUJI_APP_KEY']
      end
      
      def publish_url
        "#{host}/apps/#{name}/bus"
      end

      def protocol
        ENV['CLOUDFUJI_PROTOCOL'] || "https"
      end

      def port
        ENV['CLOUDFUJI_PORT']
      end

      def host
        cloudfuji_port = port ? ":#{port}" : ""
        cloudfuji_host = ENV['CLOUDFUJI_HOST'] || 'cloudfuji.com'
        "#{protocol}://#{cloudfuji_host}#{cloudfuji_port}"
      end

      def on_cloudfuji?
        ENV['HOSTING_PLATFORM']=="cloudfuji"
      end

      def claimed?
        (ENV['CLOUDFUJI_CLAIMED'].nil? or ENV['CLOUDFUJI_CLAIMED'].blank?) ? false : true
      end

      def metrics_token
        ENV['CLOUDFUJI_METRICS_TOKEN']
      end

      def cloudfuji_js_source
        "#{Cloudfuji::Platform.host}/api/cloudfuji.js"
      end
    end
  end
end
