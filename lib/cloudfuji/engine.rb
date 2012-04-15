require 'cloudfuji'

if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'rails'
  require 'rails/routes'

  module Cloudfuji
    class Engine < Rails::Engine
        
      initializer "cloudfuji.add_middleware" do |app|
        # Only include our middleware if its on our platform
        unless ENV['CLOUDFUJI_APP'].nil?
          app.middleware.use Cloudfuji::Middleware
        end
      end
    end
  end
else
  # Rails 2 handling
  Rails.configuration.middleware.use 'Cloudfuji::Middleware'
end
