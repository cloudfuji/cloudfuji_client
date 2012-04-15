require 'orm_adapter/adapters/mongoid'

module Cloudfuji
  module Orm
    module Mongoid
      module Hook
        def cloudfuji_modules_hook!
          extend Schema
          yield
          return unless Devise.apply_schema
          devise_modules.each { |m| send(m) if respond_to?(m, true) }
        end
      end

      module Schema
        include Cloudfuji::Schema

        # Tell how to apply schema methods
        def apply_cloudfuji_schema(name, type, options={})
          type = Time if type == DateTime
          field name, { :type => type }.merge!(options)
        end
      end
    end
  end
end

Mongoid::Document::ClassMethods.class_eval do
  include Cloudfuji::Models
  include Cloudfuji::Orm::Mongoid::Hook
end
