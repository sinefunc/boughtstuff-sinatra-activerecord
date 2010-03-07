require 'spec_helper'

describe TwitterStatusUpdate do

  before(:each) do
    FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json",
                         :body => "something")
  end

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:sender) }
  it { should validate_length_of(:body, :within => 1..140) }

end


describe TwitterStatusUpdate, "save" do

  before(:each) do
    @sender = Factory(:user)
    FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json",
                         :body => {:id   => "12345",
                                   :text => "RT @marco_palinar \"just bought a 16GB iPhone. Check it out at http://bit.ly/bsde\"",
                                   :user => {:id => @sender.twitter_id}}.to_json)
  end

  context "successful" do

    before(:each) do
      @update = TwitterStatusUpdate.new(:sender => @sender,
                                        :body   => "RT @marco_palinar \"just bought a 16GB iPhone. Check it out at http://bit.ly/bsde\"")
    end

    it "returns true" do
      @update.save.should be_true
    end

    it "sets the objects id to the status id" do
      @update.save
      @update.id.should == "12345"
    end

    it "should not be a new_record" do
      @update.save
      @update.should_not be_new_record
    end
  end

end
