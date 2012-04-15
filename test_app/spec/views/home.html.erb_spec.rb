require 'spec_helper'

describe "static/home" do
  it "should have claimed = false in the source when unclaimed" do
    render

    rendered.should have_tag("script", :text => "")
  end

  it "should have claimed = true in the source when unclaimed" do
    render

    rendered.should contain("var _cloudfuji_claimed = true;")
  end
end
