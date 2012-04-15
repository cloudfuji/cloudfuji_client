if ActionController::Routing.name =~ /ActionDispatch/
  
  # Rails 3.x

  module ActionDispatch::Routing
    class RouteSet #:nodoc:
      Mapper.class_eval do
        def cloudfuji_routes
          Rails.application.routes.draw do
            namespace 'cloudfuji' do
              resources :envs, :only => [ :update ]
              match '/data' => "data#index"

              # TODO restrict to POST-only
              match '/mail' => "mail#index"
            end
          end
        end
      end
    end
  end

else

  # Rails 2.x
  module ActionController::Routing
    class RouteSet
      
      Mapper.class_eval do
        def cloudfuji_routes
          namespace 'cloudfuji' do |cloudfuji|
            cloudfuji.resources :envs, :only => [ :update ]
            cloudfuji.connect '/data', :controller=>:data, :action=>:index
            cloudfuji.connect '/mail', :controller=>:mail, :action=>:index
          end
        end
      end

    end
  end

end
