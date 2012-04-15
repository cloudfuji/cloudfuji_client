module Cloudfuji
  module Generators
    class MailRoutesGenerator < Rails::Generators::Base
  
      def create_mail_routes_file
        # Create the lib/cloudfuji directory if it doesnt exist
        Dir.mkdir("#{Rails.root}/lib/cloudfuji") if not Dir.exists? "#{Rails.root}/lib/cloudfuji"
        
        lib "cloudfuji/mail_routes.rb" do
          <<-EOF
::Cloudfuji::Mailroute.map do |m|

  m.route("simple") do
    m.subject("hello")
  end

end
          EOF
        end

        lib("cloudfuji/hooks/email_hooks.rb") do
          <<-EOF
class CloudfujiEmailHooks < Cloudfuji::EventObserver

  def mail_simple
    puts "YAY!"
    puts params.inspect
  end

end
          EOF
        end
        
        initializer "cloudfuji_hooks.rb" do
          <<-EOF
Dir["\#{Dir.pwd}/lib/cloudfuji/**/*.rb"].each { |file| require file }
          EOF
        end
        
        initializer("cloudfuji_mail_routes.rb", "require './lib/cloudfuji/mail_routes.rb'")

      end
    end
  end
end
