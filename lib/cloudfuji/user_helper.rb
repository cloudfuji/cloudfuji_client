module Cloudfuji
  module UserHelper
    def notify(title, body, category)
      Cloudfuji::User.notify(self.ido_id, title, body, "chat")
    end
  end
end
