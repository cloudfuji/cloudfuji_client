require 'orm_adapter/adapters/active_record'

module Cloudfuji
  module Orm
    # This module contains some helpers and handle schema (migrations):
    #
    #   create_table :accounts do |t|
    #     t.database_authenticatable
    #     t.confirmable
    #     t.recoverable
    #     t.rememberable
    #     t.trackable
    #     t.lockable
    #     t.timestamps
    #   end
    #
    # However this method does not add indexes. If you need them, here is the declaration:
    #
    #   add_index "accounts", ["email"],                :name => "email",                :unique => true
    #   add_index "accounts", ["confirmation_token"],   :name => "confirmation_token",   :unique => true
    #   add_index "accounts", ["reset_password_token"], :name => "reset_password_token", :unique => true
    #
    module ActiveRecord
      module Schema
        include Cloudfuji::Schema

        # Tell how to apply schema methods.
        def apply_cloudfuji_schema(name, type, options={})
          column name, type.to_s.downcase.to_sym, options
        end
      end
    end
  end
end

module ActiveRecord
  class Base
    include Cloudfuji::Models
  end
end

ActiveRecord::ConnectionAdapters::Table.send :include, Cloudfuji::Orm::ActiveRecord::Schema
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Cloudfuji::Orm::ActiveRecord::Schema

