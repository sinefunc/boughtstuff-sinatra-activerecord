require 'spec_helper'

describe TwitterDirectMessage do
  before(:each) do
    FakeWeb.register_uri(
      :post, "http://twitter.com/direct_messages/new.json",
      :body => "something"
    )
  end

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:sender) }
  it { should validate_presence_of(:recipient) }
  it { should validate_length_of(:body, :within => 1..140) }

end

describe TwitterDirectMessage, "save" do
  context "successful" do
    before(:each) do
      @sender = Factory(:user)
      @recipient = Factory(:user)
      FakeWeb.register_uri(
        :post, "http://twitter.com/direct_messages/new.json",
        :body => { 
          :sender_id    => @sender.twitter_id,
          :recipient_id => @recipient.twitter_id,
          :id           => "88619848" 
        }.to_json
      )

      @dm = TwitterDirectMessage.new(
        :sender    => @sender,
        :recipient => @recipient,
        :body      => "Hello world"
      )

    end

    it "should set it's twitter direct message id as its id" do
      @dm.save
      @dm.id.should == "88619848"
    end

    it "should not be a new record" do
      @dm.save
      @dm.should_not be_new_record
    end

    it "returns true" do
      @dm.save.should be_true
    end
  end

end

