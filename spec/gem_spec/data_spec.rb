require "spec_helper"

describe Cloudfuji::Data do

  describe "add_observer" do
    it "should add an observer" do
      observers = ["sample_observer"]
      Cloudfuji::Data.add_observer(observers.first)
      Cloudfuji::Data.class_variable_get("@@observers").should == observers
    end
  end
  
end
