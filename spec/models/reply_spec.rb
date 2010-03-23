require 'spec_helper'

describe Reply do
  it_should_behave_like AnActiveModel

  it { should validate_length_of(:body, :within => 1..140) }
end

describe Reply, 'upon initialization with item by cyx' do
  subject { 
    Reply.new(:item => Factory(:item, 
                               :user => Factory(:user, :login => 'cyx')))
  }

  its(:body) { should == '@cyx ' }
end

describe Reply, "by cyx with a body of @cyx" do
  subject {
    Reply.new(:item => Factory(:item, 
                               :user => Factory(:user, :login => 'cyx')))

  }

  it { should_not be_valid }
  it { should have_an_invalid(:body) }
end

describe Reply, "on save when done async" do
  before( :each ) do
    @user = Factory(:user)
    @item = Factory(:item, :user => @user)
    
    @reply = Reply.new(:item => @item, :sender => @user, :body => "@user hello world")
  end

  it "should enqueue the reply body, sender_id, and item_id" do
    Resque.should_receive(:enqueue).with(
      Reply, "@user hello world", @user.id, @item.id
    )

    @reply.save(:async)
  end
end
describe Reply, "on save when done synchronously" do
  before(:each) do
    user = Factory(:user)
    item = Factory.build(:item, :user => user)
    
    @reply = Reply.new(:item => item, :sender => user, :body => "@user hello world")
  end

  it "should set the id to the status id" do
    @reply.save( :sync )
    @reply.id.should_not be_nil
  end

  it "should return true" do
    @reply.save.should be_true
  end
end
