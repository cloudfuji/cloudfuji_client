require 'spec_helper'

describe "Cloudfuji::Base" do

  def url_helpers
    {
      :unity=>[:valid,  :exists,
               :invite, :pending_invites,
               :remove],

      :email=>[:send]
    }
  end

  it "should have url helper methods" do
    url_helpers.stringify_keys.each do |prefix, method_names|
      method_names.each do |method_name|
        full_method_name = method_name.to_s + "_" + prefix + "_" + "url"
        Cloudfuji::Base.send(full_method_name.to_sym).should == "#{Cloudfuji::Platform.host}/#{prefix}/#{Cloudfuji::Config.api_version}/#{method_name}"
      end
    end
  end

end
