module Cloudfuji
  module Generators
    class RoutesGenerator < Rails::Generators::Base
  
      def create_routes_file
        prepend_to_file("config/routes.rb") do
<<-EOF
begin
  Rails.application.routes.draw do
    cloudfuji_routes
  end
rescue => e
  puts "Error loading the Cloudfuji routes:"
  puts "\#{e.inspect}"
end
EOF
        end

      end
    end
  end
end
