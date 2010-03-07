require 'spec_helper'

describe User do
  it { should validate_uniqueness_of(:login) }
  it { should validate_presence_of(:login) } 
  it { should validate_presence_of(:twitter_id) } 

  it { should have_many(:items) }
  it { should have_many(:likes) }
  it { should have_many(:likes_items) }
  it { should have_many(:liked_by_others) }
  it { should have_many(:liked_items_by_others) }
end

describe User, "with a login of marco_palinar" do
  subject { Factory(:user, :login => "marco_palinar") }

  its(:username) { should == 'marco-palinar' }
end

describe User, "with a login of reseseares but an alias rese" do
  subject { Factory(:user, :login => "reseseares", :boughtstuff_username => "rese") }

  its(:username) { should == 'rese' }
end

describe User, "who has bought 1 item worth 999" do
  before(:each) do
    @item = Factory(:item, :price_in_dollars => 999)
    @user = @item.user
  end

  def subject
    @user
  end

  its(:total_spending) { should == 999 }

  context "when the user buys another item worth 199" do
    before( :each ) do
      @item = Factory(:item, :price_in_dollars => 199, :user => @user)
    end
    
    its(:total_spending) { should == 1198 }
  end
end
