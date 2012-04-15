require 'spec_helper'

describe Cloudfuji::EnvsController do
  before(:each) do
    ENV["CLOUDFUJI_APP_KEY"] = "abc123"
  end
  
  context "updating env vars" do
    describe "PUT '/cloudfuji/envs'" do
      it "should return 405 when given the wrong key" do
        preserve_envs("CLOUDFUJI_EXAMPLE", "CLOUDFUJI_APP_KEY", "CLOUDFUJI_ENV") do
          post :update, {:key => "not-the-key", :id => "CLOUDFUJI_EXAMPLE", :value => "value"}
          ENV["CLOUDFUJI_EXAMPLE"].should be_nil
        end
      end

      it "should update the ENV var when given the right key" do
        preserve_envs("CLOUDFUJI_EXAMPLE", "CLOUDFUJI_APP_KEY", "CLOUDFUJI_ENV") do
          post :update, {:key => ENV["CLOUDFUJI_APP_KEY"].dup, :id => "CLOUDFUJI_EXAMPLE", :value => "value"}
          ENV["CLOUDFUJI_EXAMPLE"].should == "value"
        end
      end
    end
  end
end
