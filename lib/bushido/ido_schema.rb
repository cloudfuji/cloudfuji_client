# This is probably a bad idea. Feel free to kill this file if you're unsure.
module Bushido
  module IdoSchema
    class << self
      def schema_for(ido_model)
        # GET to /ido/schemas/:ido_model
        # TODO: Catch non-200 response code
        response = JSON.parse(RestClient.get("#{Bushido::Platform.host}/ido/schemas/#{ido_model}/#{ENV['BUSHIDO_PROJECT_SHA']}", :content_type => :json, :accept => :json))
        if response['ido_schema'].nil?
          return false
        end

        return response['ido_schema']
      end
    end
  end
end
