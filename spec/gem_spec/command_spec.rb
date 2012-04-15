require 'spec_helper'

describe "Cloudfuji::Command" do
  
  before :each do
    @dummy_url = "/sample_api_path"
    @api_params = @sample_result = @rest_params = {:key1=>"value1", :key2=>"value2"}
    @rest_params.merge!({:auth_token => Cloudfuji::Platform.key}) if params[:auth_token].nil? unless Cloudfuji::Platform.key.nil?
  end

  describe "last_command_successful?" do
    it "should initially return true" do
      Cloudfuji::Command.last_command_successful?.should be_true
    end
  end

  describe "last_command_errored?" do
    it "should initially return false" do
      Cloudfuji::Command.last_command_errored?.should be_false
    end
  end

  describe "request_count" do
    it "should initially be 0" do
      Cloudfuji::Command.request_count == 0
    end

    it "should return the request count" do
      Cloudfuji::Command.class_eval "@@request_count = 42"
      Cloudfuji::Command.request_count.should == 42
    end
  end

  describe "show_response" do
    before :each do
      @response = {:messages => ["value1", "value2"],
                   :errors => ["value1", "value2"]}
    end
    it "should show messages" do
      Cloudfuji::Command.should_receive(:show_messages).with(@response)
      Cloudfuji::Command.show_response(@response)
    end

    it "should show errors" do
      Cloudfuji::Command.should_receive(:show_errors).with(@response)
      Cloudfuji::Command.show_errors(@response)
    end
  end

  # GET request
  describe "get_command" do
    describe "valids" do
      before :each do
        RestClient.should_receive(:get).
          with(@dummy_url, {:params => @rest_params, :accept => :json}).
          and_return(@sample_result.to_json)
      end

      it "should increment the request count" do
        expect {
          Cloudfuji::Command.get_command(@dummy_url, @api_params)
        }.to change(Cloudfuji::Command, :request_count).by(1)
      end

      it "should set last command as successful" do
        Cloudfuji::Command.get_command(@dummy_url, @api_params)
        Cloudfuji::Command.last_command_successful?.should be_true
      end

      it "should return the request result" do
        # JSON parsing returns stringified keys
        Cloudfuji::Command.get_command(@dummy_url, @api_params).should == @sample_result.stringify_keys
      end
    end

    describe "invalids" do
      before :each do
        RestClient.should_receive(:get).
          with(@dummy_url, {:params => @rest_params, :accept => :json}).
          and_throw(:any_exception)
      end

      it "should set last command as failed" do
        Cloudfuji::Command.get_command(@dummy_url, @api_params)
        Cloudfuji::Command.last_command_errored?.should be_true
      end

      it "should return nil" do
        Cloudfuji::Command.get_command(@dummy_url, @api_params).should == nil
      end
    end
  end

  # POST request
  describe "post_command" do
    describe "valids" do
      before :each do
        RestClient.should_receive(:post).
          with(@dummy_url, @rest_params.to_json, :content_type => :json, :accept => :json).
          and_return(@sample_result.to_json)
      end
     
      it "should increment the request count" do
        expect {
          Cloudfuji::Command.post_command(@dummy_url, @api_params)
        }.to change(Cloudfuji::Command, :request_count).by(1)
      end

      it "should set last command as successful" do
        Cloudfuji::Command.post_command(@dummy_url, @api_params)
        Cloudfuji::Command.last_command_successful?.should be_true
      end

      it "should return the request result" do
        Cloudfuji::Command.post_command(@dummy_url, @api_params).should == @sample_result.stringify_keys
      end
    end

    describe "invalids" do
      before :each do
        RestClient.should_receive(:post).
          with(@dummy_url, @rest_params.to_json, :content_type => :json, :accept => :json).
          and_throw(:exception)
      end

      it "should set last command as failed" do
        Cloudfuji::Command.post_command(@dummy_url, @api_params)
        Cloudfuji::Command.last_command_errored?.should be_true
      end

      it "should return nil" do
        Cloudfuji::Command.post_command(@dummy_url, @api_params).should == nil
      end
    end
  end

  # PUT request
  describe "put_command" do
    describe "valids" do
      before :each do
        RestClient.should_receive(:put).
          with(@dummy_url, @rest_params.to_json, :content_type => :json).
          and_return(@sample_result.to_json)
      end
     
      it "should increment the request count" do
        expect {
          Cloudfuji::Command.put_command(@dummy_url, @api_params)
        }.to change(Cloudfuji::Command, :request_count).by(1)
      end

      it "should set last command as successful" do
        Cloudfuji::Command.put_command(@dummy_url, @api_params)
        Cloudfuji::Command.last_command_successful?.should be_true
      end

      it "should return the request result" do
        Cloudfuji::Command.put_command(@dummy_url, @api_params).should == @sample_result.stringify_keys
      end
    end

    describe "invalids" do
      before :each do
        RestClient.should_receive(:put).
          with(@dummy_url, @rest_params.to_json, :content_type => :json).
          and_throw(:exception)
      end

      it "should set last command as failed" do
        Cloudfuji::Command.put_command(@dummy_url, @api_params)
        Cloudfuji::Command.last_command_errored?.should be_true
      end

      it "should return nil" do
        Cloudfuji::Command.put_command(@dummy_url, @api_params).should == nil
      end
    end

  end

end
