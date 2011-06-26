require 'test_helper'

class EnvsControllerTest < ActionController::TestCase
  tests Bushido::EnvsController
  
  # test "should route to envs" do
  #   assert_routing '/', { :controller => "application", :action => "turd"}
  #   #assert_routing '/bushido/envs/1.json', { :controller => "envs", :action => "update"}
  # end
  test "updates env var on post" do
    post :controller => :envs, :action => :update,
     :params => {
      :key => ENV["BUSHIDO_APP_KEY"],
      :id => "env_id",
      :value => "env_value"
    }
    
    assert_equal 200, response.status
    assert_equal ENV["env_id"], "env_value"
  end
end