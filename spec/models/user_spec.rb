require 'spec_helper'

describe User do
  it { should validate_presence_of(:login) }
  it { should validate_presence_of(:twitter_id) }
  it { should validate_presence_of(:name) }
end

describe User, "with login of marco_palinar" do
  subject { Factory(:user, :login => 'marco_palinar') }

  context "after saving" do
    its(:username) { should == 'marco-palinar' }

    it "should be retrievable via find_by_username" do
      should == User.find_by_username('marco-palinar')
    end
  end
end

describe User, "with a login of reseseares and alias of rese" do
  subject { Factory(:user, :login => 'reseseares', :nickname => 'rese') }
  
  it "should be retrievable via find_by_username rese" do
    should == User.find_by_username('rese')
  end

  it "should be retrievable via find_by_username reseseares" do
    should == User.find_by_username('reseseares')
  end
end

describe User, "#find_or_create_by" do
  context "given finding or creating given an id of 1001" do
    before(:each) do
      User.find_or_create_by(
        id: 1001, screen_name: 'cyx', name: 'Cyril David',
        profile_image_url: 'http://images/avatar.jpg'
      )
    end
    
    context "the found user with twitter_id: 1001" do
      subject { User.first(twitter_id: 1001) }

      it { should_not be_nil }
      its(:login)      { should == 'cyx' }
      its(:username)   { should == 'cyx' }
      its(:name)       { should == 'Cyril David' }
      its(:avatar_url) { should == 'http://images/avatar.jpg' }
    end
  end
end
