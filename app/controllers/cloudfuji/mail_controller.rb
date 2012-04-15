# -*- coding: utf-8 -*-
module Cloudfuji
  class MailController < ApplicationController

    # POST /cloudfuji/mail
    def index
      puts "Handling email!"
      mail = {}
      attachments = []

      # Strip the attachments first
      params.keys.each do |key|
        attachments << params.delete(key) if key =~ /attachment-\d+/
      end

      # Copy the params to the hook data
      (params.keys - ["controller", "action"]).each do |param|
        mail[param.downcase] = params[param]
      end

      mail["attachments"] = attachments

      puts "params: #{params.inspect}"
      puts "mail: #{mail.inspect}"

      # Output for debugging remotely
      Cloudfuji::Mailroute.pretty_print_routes
      puts "Finished routing"
      
      # Mailroute is in charge of figuring out which callback to trigger
      Cloudfuji::Mailroute.routes.process(mail)

      result = {:success => true, :message => nil, :data => {}}
      render :text => result.to_json, :status => 200
    end
  end
end
