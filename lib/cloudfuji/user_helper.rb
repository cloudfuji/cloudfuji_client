module Cloudfuji
  module UserHelper
    def notify(title, body, category = "chat")
      Cloudfuji::User.notify(self.ido_id, title, body, category)
    end
  end
end
