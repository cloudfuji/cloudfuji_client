ENV["RAILS_ENV"] = "test"
ENV["BUSHIDO_APP_KEY"] = "bushidoappkey"
require "rubygems"
require "bundler"
Bundler.setup

require "rails_app/config/environment"
require "rails/test_help"
require "rails/generators/test_case"