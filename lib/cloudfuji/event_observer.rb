module Cloudfuji
  class EventObserver
    attr_accessor :params

    def self.inherited(klass)
      if Cloudfuji::Platform.on_cloudfuji?
        Cloudfuji::Data.add_observer(klass.new)
      else
      end
    end

    def initialize
      @params ||= {}
    end

    def data
      @params['data']
    end
  end
end
