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
    should == "just bought #{'A' * 64} http://boughtstuff.com/marcopalinar#1001 #boughtstuff" 
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
    should == "just bought iPod Touch http://boughtstuff.com/marcopalinar#1001 #boughtstuff" 
  }
end

describe Purchase, "with an Item of 140 chars by abcdefghijklmno with 10 digits" do
  subject do
    item = Factory.build(:item, :name => ('A' * 140),
                         :user => Factory(:user, :login => 'abcdefghijklmno'))
    item.id = 1000000000
    item.save!

    Purchase.new(:item => item, :sender => item.user)
  end
  
  it { should be_valid }

  its(:body) { 
    subject.length.should == 139
  }
end


