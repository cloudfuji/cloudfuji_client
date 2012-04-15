require 'spec_helper'

describe "Cloudfuji::Platform" do
  describe "publish_url" do
    it "should return publish url" do
      Cloudfuji::Platform.publish_url.should == "#{Cloudfuji::Platform.host}/apps/#{Cloudfuji::Platform.name}/bus"
    end
  end
end
