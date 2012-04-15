#require 'rack/utils'

module Cloudfuji
  class Middleware
    include Rack::Utils

    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      if Cloudfuji::Platform.on_cloudfuji? and Cloudfuji::Bar.in_bar_display_path?(env)
        status, headers, response = @app.call(env)

        content = ""
        response.each { |part| content += part }

        # "claiming" bar + stats ?
        content.gsub!(/<\/body>/i, <<-STR
            <script type="text/javascript">
              var _cloudfuji_app = '#{Cloudfuji::Platform.name}';
              var _cloudfuji_claimed = #{Cloudfuji::Platform.claimed?.to_s};
              var _cloudfuji_metrics_token = '#{Cloudfuji::Platform.metrics_token}';
              (function() {
                var cloudfuji = document.createElement('script'); cloudfuji.type = 'text/javascript'; cloudfuji.async = true;
                cloudfuji.src = '#{Cloudfuji::Platform.cloudfuji_js_source}?t=#{::Cloudfuji::VERSION.gsub('.', '')}';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(cloudfuji, s);
              })();
            </script>     
          </body>
        STR
        )

        headers['content-length'] = bytesize(content).to_s
        [status, headers, [content]]
      else
        @app.call(env)
      end
    end
  end
end

