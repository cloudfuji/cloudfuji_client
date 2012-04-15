module Cloudfuji
  class SMTP
    class << self
      [:tls, :server, :port, :domain, :authentication, :user, :password].each do |method_name|
        define_method "#{method_name}".to_sym do
          ENV["SMTP_#{method_name.to_s.upcase}"]
        end
      end

      def setup_action_mailer_smtp!
        ActionMailer::Base.smtp_settings = {
          :enable_starttls_auto => Cloudfuji::SMTP.tls,
          :tls =>                  Cloudfuji::SMTP.tls,
          :address =>              Cloudfuji::SMTP.server,
          :port =>                 Cloudfuji::SMTP.port,
          :domain =>               Cloudfuji::SMTP.domain,
          :authentication =>       Cloudfuji::SMTP.authentication,
          :user_name =>            Cloudfuji::SMTP.user,
          :password =>             Cloudfuji::SMTP.password,
        }
      end
    end
  end
end
