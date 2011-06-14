module Bushido
  class Data #:nodoc:
    
    @@hooks = {}
    
    class << self
      def fire data, *hooks
        unless @@hooks[:global].nil?
          @@hooks[:global].call('global', data)
        end
        
        if hooks.length > 0
          hooks.each do |h|          
            unless @@hooks[h].nil? 
              @@hooks[h].call(h, data)
            end
          end
        end
      end
      
      def listen *hooks, &block
        if hooks.empty? and block_given?
          @@hooks[:global] = block
        elsif !hooks.nil? and block_given?
          hooks.each do |h|
            @@hooks[h] = block
          end
        end
      end
      
      # POST /apps/:id/bus
      def publish(model, model_data)
        data = {}
        data[:key] = Bushido::Platform.key

        data["data"]  = model_data
        data["data"]["bushido_model"] = model
        puts "Publishing bushido model"
        puts data.to_json
        puts Bushido::Platform.publish_url
        RestClient.post(Bushido::Platform.publish_url, data.to_json, :content_type => :json, :accept => :json)
      end
    end
  end
end
