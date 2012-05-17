module Cloudfuji
  class Data #:nodoc:
    @@observers = []

    class << self
      def add_observer(observer)
        puts "Subscribing #{observer} to Cloudfuji data calls"
        @@observers << observer
      end

      # Returns an array of the unique instance methods defined
      # for all observers, except #catch_all
      def observed_events
        @@observers.map {|observer|
          observer.class.instance_methods - Cloudfuji::EventObserver.instance_methods
        }.flatten.uniq - [:catch_all]
      end

      def fire(data, event)
        puts "Cloudfuji Hooks Firing #{event} with => #{data.inspect}"

        halted = false
        @@observers.each do |observer|
          # Test if each observer responds to the named event, or #catch_all
          [event, :catch_all].each do |method|
            # Process observer if event propagation isn't halted,
            # or we are trying the #catch_all method
            # (All #catch_all methods should be processed regardless of
            #  halted status)
            if !halted || method == :catch_all
              puts "#{observer}.respond_to?(#{method}) => #{observer.respond_to?(method)}"

              if observer.respond_to?(method)
                # Make a copy of the data so it's not mutated as the events
                # pass through the observers
                observer.instance_variable_set("@params", data.dup)

                result = observer.send(method)

                # Allow an observer to halt event propagation for
                # other named event methods
                if result == :halt
                  puts "Observer #{observer} halted event propagation"
                  halted = true
                end
              end
            end
          end
        end
      end
    end
  end
end
