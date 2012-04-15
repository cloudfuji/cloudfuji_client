module Cloudfuji
  module Models
    def self.included(base)
      base.extend ClassMethods
    end

    def cloudfuji_save
      # It's possible we're saving an item just handed to us by Cloudfuji, so we
      # don't want to re-publish it. We can detect it using the version.
      
      puts "what"
      # cloudfuji_id.nil? This is new, it's from us (otherwise cloudfuji would have given it an id), we should publish it.
      # cloudfuji_version == self.find(self.id).cloudfuji_version The version hasn't changed, our data has, we should publish it
      puts "new_record? #{self.new_record?}"
      puts "self.id = #{self.id}"
      puts "ido_id.nil? #{ido_id.nil?}"
      puts "ido_version == self.class.find(self.id).ido_version ? #{ido_version == self.class.find(self.id).ido_version}" unless self.new_record?
      if self.ido_id.nil? or (not self.new_record? and self.ido_version == self.class.find(self.id).ido_version)
        puts "Local change, publishing to Cloudfuji databus"

        data = self.to_cloudfuji

        begin
          response = Cloudfuji::Data.publish(self.class.class_variable_get("@@ido_model"), data)
        rescue => e
          puts e.inspect
          # TODO: Catch specific exceptions and bubble up errors (e.g. 'cloudfuji is down', 'model is malformed', etc.)
          return false
        end

        self.ido_version = response["ido_version"]
        self.ido_id ||= response["ido_id"]

        puts response.inspect
      else
        puts "Remote change, not publishing to Cloudfuji databus"
      end

      return true
    end

    module ClassMethods
      def cloudfuji model
        self.class_variable_set("@@ido_model", model)

        [:create, :update, :destroy].each do |event|
          puts "Hooking into #{model}.#{event}..."

          Cloudfuji::Data.listen("#{model}.#{event}") do |data, hook|
            puts "#{hook}.) Firing off #{model}.#{event} now with data: #{data}"
            self.send("on_cloudfuji_#{event}".to_sym, self.from_cloudfuji(data))
          end
        end
        
        before_save :cloudfuji_save
      end
    end
  end
end
