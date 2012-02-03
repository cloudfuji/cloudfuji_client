module Bushido
  class Data #:nodoc:
    @@observers = []

    def self.add_observer(observer)
      puts "Subscribing #{observer} to Bushido data calls"
      @@observers << observer
    end
    
    def self.fire(data, event)
      puts "Bushido Hooks Firing #{event} with => #{data.inspect}"
      @@observers.each do |observer|
        puts "#{observer}.respond_to?(#{event}) => #{observer.respond_to?(event)}"
        if observer.respond_to?(event) || observer.respond_to?(:catch_all)
          # Make a copy of the data so it's not mutated as the events
          # pass through the observers
          observer.instance_variable_set("@params", data.dup)
          if observer.respond_to?(event)            
            observer.send(event)
          else
            observer.send(:catch_all)
          end
        end
      end
    end
  end
end
