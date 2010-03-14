require 'spec_helper'

describe Retweet do
  it_should_behave_like AnActiveModel

  it { should validate_length_of(:body, :within => 1..140) }
end

describe Retweet, "with an item name of 140 A's and an ID of 1001" do
  subject do
    item = Factory.build(:item, :name => ("A" * 140),
                         :user => Factory(:user, :login => 'marcopalinar'))

    item.id = 1001
    item.save!

    Retweet.new(:item => item, :sender => Factory(:user))
  end

  it { should be_valid }

  its(:body) {
    should == "RT @marcopalinar: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA http://marcopalinar.boughtstuff.com/#1001 #boughtstuff"
  }
end

describe Retweet, "with an Item of 140 chars by abcdefghijklmno with 10 digits" do
  subject do
    item = Factory.build(:item, :name => ('A' * 140),
                         :user => Factory(:user, :login => 'abcdefghijklmno'))
    item.id = 1234567890
    item.save!

    Retweet.new(:item => item, :sender => item.user)
  end
  
  it { should be_valid }

  its(:body) { 
    subject.length.should == 139
  }
end
