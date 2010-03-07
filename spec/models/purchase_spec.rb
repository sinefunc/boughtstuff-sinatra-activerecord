require 'spec_helper'

describe Purchase do
  it_should_behave_like AnActiveModel

  it { should validate_length_of(:body, :within => 1..140) }
end

describe Purchase, "with an item name of 140 A's and an ID of 1001" do
  subject do
    item = Factory.build(:item, :name => ("A" * 140), 
                         :user => Factory(:user, :login => 'marcopalinar'))
    item.id = 1001
    item.save!

    Purchase.new(:item => item, :sender => item.user)
  end
  
  it { should be_valid }

  its(:body) { 
    should == "just bought #{'A' * 63} http://marcopalinar.boughtstuff.com/#1001 #boughtstuff" 
  }

  its(:body) {
    subject.length.should == 130
  }
end

describe Purchase, "with an item name of iPod Touch and an ID of 1001" do
  subject do
    item = Factory.build(:item, :name => 'iPod Touch',
                         :user => Factory(:user, :login => 'marcopalinar'))
    item.id = 1001
    item.save!

    Purchase.new(:item => item, :sender => item.user)
  end
  
  it { should be_valid }

  its(:body) { 
    should == "just bought iPod Touch http://marcopalinar.boughtstuff.com/#1001 #boughtstuff" 
  }
end

describe Purchase, "#post" do
  before(:each) do
    FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json",
                         :body => {:id => 123145}.to_json)
  end

  subject do
    item = Factory.build(:item, :name => 'iPod Touch',
                         :user => Factory(:user, :login => 'marcopalinar'))
    item.id = 1001
    item.save!

    Purchase.post(item, item.user)
  end
  
  it "should return the twitter status id" do 
    should == '123145'
  end
end

describe Purchase, "with an Item of 140 chars by abcdefghijklmno with 11 digits" do
  subject do
    item = Factory.build(:item, :name => ('A' * 140),
                         :user => Factory(:user, :login => 'abcdefghijklmno'))
    item.id = 10000000000
    item.save!

    Purchase.new(:item => item, :sender => item.user)
  end
  
  it { should be_valid }

  its(:body) { 
    subject.length.should == 140
  }
end


