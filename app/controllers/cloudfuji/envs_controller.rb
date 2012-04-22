module Cloudfuji
  class EnvsController < ApplicationController
    # PUT /cloudfuji/envs/:id
    def update
      if ENV["CLOUDFUJI_APP_KEY"] != params[:key] or params[:id] == "CLOUDFUJI_KEY"
        respond_to do |format|
          format.html { render :layout => false, :text => true, :status => :forbidden }
          format.json { render :json => {:error => "Not authorized to submit data to this app" }, :status => :unprocessable_entity }
        end

      else

        var = params[:id].upcase

        ENV[var] = params[:value]
        @value = ENV[var]
        
        respond_to do |format|
          if @value != ENV[var]
            format.html{render :layout => false, :text => true, :status => :unprocessable_entity}
            format.json{render :status => :unprocessable_entity}
          else
            Cloudfuji::Data.fire(var, {var => ENV[var]})
            format.html{render :text => true}
            format.json{render :json => {var => ENV[var]}}
          end
        end
      end
    end
  end
end
