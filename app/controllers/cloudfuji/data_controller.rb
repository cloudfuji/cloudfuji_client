module Cloudfuji
  class DataController < ApplicationController
    
    # POST /cloudfuji/data/
    def index
      @key = params.delete("key")

      if ENV["CLOUDFUJI_APP_KEY"] != @key
        respond_to do |format|
          format.html { render :layout => false, :text => true, :status => :forbidden }
          format.json { render :json => {:error => "Not authorized to submit data to this app" }, :status => 401 }
        end

        return
      end
      
      puts "Idobus Data rec'd: #{params.inspect}"
      puts params["category"].inspect

      hook_data             = {}
      hook_data["category"] = params["category"]
      hook_data["event"]    = params["event"]
      hook_data["data"]     = params["data"]

      puts "Firing with: #{hook_data.inspect}"
      event = "#{params['category']}.#{params['event']}".gsub('.', '_').to_sym

      Cloudfuji::Data.fire(hook_data, event)

      respond_to do |format|
        format.json {render :json => {'acknowledged' => true}, :status => 200}
      end
    end
  end
end
