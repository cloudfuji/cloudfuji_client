require 'generators/cloudfuji/orm_helpers'

module Mongoid
  module Generators
    class cloudfujiGenerator < Rails::Generators::NamedBase
      include cloudfuji::Generators::OrmHelpers

      def generate_model
        invoke "mongoid:model", [name] unless model_exists?
      end

      def inject_cloudfuji_content
        inject_into_file model_path, model_contents, :after => "include Mongoid::Document\n"
      end
    end
  end
end
