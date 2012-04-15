namespace :cloudfuji do
  desc "Show the existing Mailroutes"
  task :mail_routes => :environment do
    Cloudfuji::Mailroute.pretty_print_routes
  end
end
