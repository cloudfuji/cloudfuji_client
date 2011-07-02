module Bushido
  class Data #:nodoc:
    
    extend Hooks

    class << self
      def attach(*models)
        # Total no-op, we just need to load the classes in order to
        # register the hooks, and this does that.
      end

      def bushido_data(model, model_data)
        puts "prepping publish data..."
        data = {}
        data[:key] = Bushido::Platform.key


        data["data"]  = model_data
        puts data.inspect
        data["data"]["ido_model"] = model
        puts "Publishing Ido model"
        puts data.to_json
        puts Bushido::Platform.publish_url

        return data
      end

      
      def publish(model, model_data, verb=:post)
        puts "in the Data::Publish method"
        # POST to /apps/:id/bus
        data = bushido_data(model, model_data)

        puts "got the data"
        url = Bushido::Platform.publish_url
        puts "url: #{url} , verb #{verb}"
        
        if verb == :delete
          verb = :put
          url += "/#{data['data']['ido_id']}"
        end

        puts "Publishing to: #{url}"
        
        # TODO: Catch non-200 response code
        response = JSON.parse(RestClient.send(verb, url, data.to_json, :content_type => :json, :accept => :json))
        if response['ido_id'].nil? or response['ido_version'].nil?
          return false
        end

        return response
      end
    end
  end
end
