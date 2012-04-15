module Cloudfuji
  class Data #:nodoc:
    @@observers = []

    def self.add_observer(observer)
      puts "Subscribing #{observer} to Cloudfuji data calls"
      @@observers << observer
    end
    
    def self.fire(data, event)
      puts "Cloudfuji Hooks Firing #{event} with => #{data.inspect}"

      processed = false

      @@observers.each do |observer|
        puts "#{observer}.respond_to?(#{event}) => #{observer.respond_to?(event)}"

        if observer.respond_to?(event)
          processed = true

          # Make a copy of the data so it's not mutated as the events
          # pass through the observers
          observer.instance_variable_set("@params", data.dup)

          result = observer.send(event)

          # Allow an observer to halt event propagation
          if result == :halt
            puts "Observer #{observer} halted event propagation"
            break
          end
        end
      end

      # We've checked all the observers to see if they respond to the
      # named events, so if the event is still unprocessed then let's
      # fall back on the first catch_all event we find
      if !processed
        @@observers.each do |observer|
          if observer.respond_to?(:catch_all)
            observer.instance_variable_set("@params", data.dup)

            observer.send(:catch_all)
            break
          end
        end
      end
    end
  end
end


