module Bushido
  module Models
    def self.included(base)
      base.extend ClassMethods
    end

    def posh
      puts "posh"
    end

    def to_ido
      data = {}
      
      self.class.ido_schema.each do |schema_field|
        data[schema_field] = self.send(schema_field.to_sym)
      end

      data
    end


    def ido_destroy
      unless self.ido_id.nil?
        puts "Global IdoData, publishing destroy event to Bushido databus"

        data = self.to_ido

        puts "This is the data I *want* to publish: #{data.inspect}"

        begin
          response = Bushido::Data.publish(self.class.class_variable_get("@@ido_model"), data, :delete)
        rescue => e
          puts e.inspect
          # TODO: Catch specific exceptions and bubble up errors (e.g. 'bushido is down', 'model is malformed', etc.)
          return false
        end

        self.ido_version = response["ido_version"]
        self.ido_id ||= response["ido_id"]

        puts response.inspect
      else
        puts "Remote change, not publishing to Bushido databus"
      end

      return true
    end



    def ido_save
      # It's possible we're saving an item just handed to us by Bushido, so we
      # don't want to re-publish it. We can detect it using the version.

      # bushido_id.nil? This is new, it's from us (otherwise bushido would have given it an id), we should publish it.
      # bushido_version == self.find(self.id).bushido_version The version hasn't changed, our data has, we should publish it
      puts "new_record? #{self.new_record?}"
      puts "self.id = #{self.id}"
      puts "ido_id.nil? #{ido_id.nil?}"
      puts "ido_version == self.class.find(self.id).ido_version ? #{ido_version == self.class.find(self.id).ido_version}" unless self.new_record?
      if self.ido_id.nil? or (not self.new_record? and self.ido_version == self.class.find(self.id).ido_version)
        puts "Local change, publishing to Bushido databus"

        data = self.to_ido

        begin
          response = Bushido::Data.publish(self.class.class_variable_get("@@ido_model"), data)
        rescue => e
          puts e.inspect
          # TODO: Catch specific exceptions and bubble up errors (e.g. 'bushido is down', 'model is malformed', etc.)
          return false
        end

        self.ido_version = response["ido_version"]
        self.ido_id ||= response["ido_id"]

        puts response.inspect
      else
        puts "Remote change, not publishing to Bushido databus"
      end

      return true
    end

    module ClassMethods
      def ido model
        self.class_variable_set("@@ido_model", model)

        [:create, :update, :destroy].each do |event|
          puts "Hooking into #{model}.#{event}..."

          Bushido::Data.listen("#{model}.#{event}") do |data, hook|
            puts "#{hook}.) Firing off #{model}.#{event} now with data: #{data}"
            self.send("on_ido_#{event}".to_sym, self.from_ido(data))
          end
        end
        
        before_save :ido_save
        before_destroy :ido_destroy
      end

      def from_ido(incoming_json)
        model = self.new
        puts model.inspect
        
        ido_schema.each do |schema_field|
          model.send("#{schema_field}=".to_sym, incoming_json[schema_field])
        end

        model
      end

      
      def on_ido_create(ido_app)
        ido_app.save
      end

      def on_ido_update(ido_app)
        app = self.find_or_create_by_ido_id(ido_app.ido_id)
        
        ido_schema.each do |schema_field|
          app.send("#{schema_field}=".to_sym, ido_app[schema_field])
        end

        app.save
      end

      def on_ido_destroy(ido_app)
        self.find_by_ido_id(ido_app.ido_id).try(:destroy)
      end
    end
  end
end
