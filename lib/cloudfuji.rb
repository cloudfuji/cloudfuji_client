module Cloudfuji #:nodoc:
  require 'optparse'
  require 'rest_client'
  require 'json'
  require 'highline/import'
  require 'orm_adapter'
  require 'rails/version'
  require 'action_controller'
  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    require "action_dispatch"
  end
  require "rails/routes"
  require 'cloudfuji/engine'
  require "cloudfuji/base"
  require "cloudfuji/bar"
  require "cloudfuji/config"
  require "cloudfuji/smtp"

  require "hooks"
  require "cloudfuji/platform"
  require "cloudfuji/utils"
  require "cloudfuji/command"
  require "cloudfuji/app"
  require "cloudfuji/user"
  require "cloudfuji/event"
  require "cloudfuji/expectation"
  require "cloudfuji/version"
  require "cloudfuji/envs"
  require "cloudfuji/data"
  require "cloudfuji/middleware"
  require "cloudfuji/models"
  require "cloudfuji/schema"
  require "cloudfuji/event_observer"
  require "cloudfuji/mail_route"
  require "cloudfuji/user_helper"

  # Manually require the controllers for rails 2
  if defined?(Rails) && Rails::VERSION::MAJOR == 2
    base_dir = "#{File.dirname(__FILE__)}/.."

    require "#{base_dir}/app/controllers/cloudfuji/data_controller"
    require "#{base_dir}/app/controllers/cloudfuji/mail_controller"
    require "#{base_dir}/app/controllers/cloudfuji/envs_controller"
    require "cloudfuji/action_mailer"
  end

  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    Cloudfuji::SMTP.setup_action_mailer_smtp!
  end

  # Default way to setup Cloudfuji. Run rails generate cloudfuji_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
