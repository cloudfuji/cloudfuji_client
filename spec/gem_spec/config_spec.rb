require 'spec_helper'

describe "Cloudfuji::Config" do
  
  it "should have API version" do
    Cloudfuji::Config.api_version.should be_a_kind_of(String)
  end

end
