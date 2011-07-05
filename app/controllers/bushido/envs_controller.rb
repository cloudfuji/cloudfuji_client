module Bushido
  class EnvsController < ApplicationController
    # PUT /bushido/envs/:id
    def update
      logger.info "Updating ENV vars!"
      logger.info "params: #{params.inspect}"

      if Bushido::Platform.key != params[:key] or params[:id] == Bushido::Platform.key
        logger.info "key didn't match! #{Bushido::Platform.key} != #{params[:key]}"
        respond_to do |format|
          format.html { render :layout => false, :text => true, :status => :forbidden }
          format.json { render :status => :unprocessable_entity }
          return
        end
      end

      logger.info "next: #{params[:id]} = #{ENV[params[:id]]}"

      ENV[params[:id]] = params[:value]
      @value = ENV[params[:id]]

      logger.info "next: #{params[:id]} = #{ENV[params[:id]]}"

      respond_to do |format|
        if @value != ENV[params[:id]]
          format.html{render :layout => false, :text => true, :status => :unprocessable_entity}
          format.json{render :status => :unprocessable_entity}
        else
          puts "Firing update hooks method from controller"
          Bushido::Envs.fire(params[:id], {params[:id] => ENV[params[:id]]})
          format.html{render :text => true}
          format.json{render :json => {params[:id] => ENV[params[:id]]}}
        end
      end
    end
  end
end
