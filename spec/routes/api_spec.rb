require 'spec_helper'

describe "POST /api/v1/items" do
  include Rack::Test::Methods
  
  def app
    Main.new
  end

  context "when not authorized" do
    before( :each ) do
      post "/api/v1/items.json"    
    end
    
    it { last_response.body.should == "Authorization Required" }
  end

  describe "given authorized scenario" do
    before( :each ) do
      authorize Sinatra::Authorization::USER, Sinatra::Authorization::PASS
    end

    context "when no user login given" do 
      before( :each ) do
        post "/api/v1/items.json"    
      end

      it do
        last_response.body.should match(/not found/i)
      end
    end

    context "when a valid user login is given but invalid item params" do
      before(:each) do
        @user = Factory(:user)
        post "/api/v1/items.json", :login => @user.login
      end

      it { last_response.status.should == 200 } 
      it "should have errors" do
        JSON.parse(last_response.body)['errors'].should_not be_nil
      end
    end

    context "when a valid user login is given with valid item params" do
      before(:each) do
        @user = Factory(:user)
        
        FakeWeb.register_uri(
          :get, "http://example.com/avatar.jpg",
          :body => File.read(root_path('spec/fixtures/files/avatar.jpg'))
        )

        post "/api/v1/items.json", :login => @user.login, 
          :item => Factory.attributes_for(:item_with_photo_url)
      end

      it { last_response.status.should == 200 }
      
      context "the JSON response" do
        def subject
          Hashie::Mash.new(
            JSON.parse(last_response.body)
          )
        end

        its(:errors) { should be_nil }
        its(:name)   { should == 'Macbook Pro 15' } 
        its(:user_id) { should == @user.id }
      end
    end
  end
end
