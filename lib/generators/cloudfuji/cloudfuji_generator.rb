module Cloudfuji
  module Generators
    class CloudfujiGenerator < Rails::Generators::NamedBase
      namespace "cloudfuji"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with Cloudfuji " <<
           "configuration plus a migration file and devise routes."

      hook_for :orm

    end
  end
end
