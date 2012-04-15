require 'rails/generators/active_record'
require 'generators/cloudfuji/orm_helpers'

module ActiveRecord
  module Generators
    class CloudfujiGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      include Cloudfuji::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists?
      end

      def copy_cloudfuji_migration
        migration_template "migration.rb", "db/migrate/cloudfuji_create_#{table_name}"
      end

      def inject_cloudfuji_content
        inject_into_class model_path, class_name, model_contents + <<-CONTENT
  # Setup accessible (or protected) attributes for your model
  attr_accessible :cloudfuji_id, :cloudfuji_version
CONTENT
      end
    end
  end
end
