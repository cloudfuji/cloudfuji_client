require 'spec_helper'

describe 'claiming an app' do
  it "marks claimed = false in the markup" do
    visit "/"
    #page.body.include?("var _cloudfuji_claimed = false;").should be_true
  end

  it "marks claimed = false in the markup" do
    preserve_envs("CLOUDFUJI_CLAIMED") do
      ENV["CLOUDFUJI_CLAIMED"] = "true"
      visit "/"
      #page.body.include?("var _cloudfuji_claimed = true;").should be_true
    end
  end
end
