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

describe Purchase, "with an Item and a description got it in thanks giving" do
  subject do
    item = Factory.build(:item, :name => "Magic Mouse",
                         :description => "Got it in thanks giving",
                         :user => Factory(:user, :login => "cyx"))
    
    item.id = 1001
    item.save!

    Purchase.new(:item => item, :sender => item.user)
  end

  its(:body) { 
    should == "Got it in thanks giving http://boughtstuff.com/cyx#1001 #boughtstuff" 
  }
end

describe Purchase, "with an Item and a description Lorem..." do
  subject do
    item = Factory.build(:item, :name => "Magic Mouse",
                         :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                         :user => Factory(:user, :login => "abcdefghijklmno"))
    
    item.id = 1000000000
    item.save!

    Purchase.new(:item => item, :sender => item.user)
  end

  its(:body) { subject.length.should == 139 }
  its(:body) { should == "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tem http://boughtstuff.com/abcdefghijklmno#1000000000 #boughtstuff" }
end
