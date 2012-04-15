module Cloudfuji
  # Cloudfuji User enables user validation against Cloudfuji's server
  class User < Cloudfuji::Base
    class << self
      
      # Checks whether user an email and password correspond to a valid cloudfuji
      # user. Returns nil if false, or the Cloudfuji user's ID if true.
      def valid?(email, pass)
        params = {}
        params[:email] = email
        params[:pass] = pass
        Cloudfuji::Command.post_command(valid_unity_url, params)
      end

      # Checks whether email corresponds to a valid Cloudfuji user.
      # Returns true or false
      def exists?(email)
        params = {}
        params[:email] = email
        Cloudfuji::Command.post_command(exists_unity_url, params)
      end

      # send a Cloudfuji invite with a short description of the app (also a box of chocolates, if he's a Kryptonian)
      # Cloudfuji::User.invite("clark@kent-on-krypton.com")
      def invite(email)
        params = {}
        params[:email] = email
        Cloudfuji::Command.post_command(invite_unity_url, params)
      end

      # List all pending invites
      # Cloudfuji::User.pending_invites
      def pending_invites
        params = {}
        Cloudfuji::Command.get_command(pending_invites_unity_url, params)
      end

      # To remove a user from an application
      # Cloudfuji::User.remove("5z325f4knbm2f")
      def remove(ido_id)
          params = {}
          params[:ido_id] = ido_id
          Cloudfuji::Command.post_command(remove_unity_url, params)
      end

      # To send a notification to a user who belongs to your app
      # Cloudfuji::User.notify('5z325f4knbm2f', 'Example title', 'Example message', 'chat')
      def notify(ido_id, title, body, category="general")
        params            = {}
        params[:ido_id]   = ido_id
        params[:title]    = title
        params[:body]     = body
        params[:category] = category

        Cloudfuji::Command.post_command(notify_user_url, params)
      end
    end
  end
end
