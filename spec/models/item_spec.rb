require 'spec_helper'
require 'resque'

describe Item do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price_in_dollars) }
  it { should validate_numericality_of(:price_in_dollars, :allow_blank => true) }
  it { should validate_length_of(:name, :maximum => 255) }
  it { should belong_to(:user) }
end

describe Item, 'with price_in_dollars of 1500' do
  subject { Item.new(:price_in_dollars => 1500) }

  its(:price) { should == 1500_00 }
end

describe Item, 'with price_in_dollars of FooBar' do
  subject { Item.new(:price_in_dollars => 'FooBar') }

  its(:price_in_dollars) { should == 'FooBar' }
end

describe Item, "with price_in_dollars of '10'" do
  subject { Item.new(:price_in_dollars => '10') }

  its(:price) { should == 1000 }
end

describe Item, "with a price_in_dollars of -10" do
  subject { Item.new(:price_in_dollars => -10) }

  its(:price) { should == -1000 }
  
  it { should have_an_invalid(:price_in_dollars) }
end

describe "given today is April fools" do
  before(:each) { Timecop.freeze Time.utc( 2010, 04, 01 ) }

  describe Item, "bought yesterday" do
    subject { Item.new(:when => 'Yesterday') }

    its(:when) { should == Date.new( 2010, 03, 31 ) }
  end

  describe Item, "bought today" do
    subject { Item.new(:when => 'Today') }

    its(:when) { should == Date.new( 2010, 04, 01 ) }
  end

  describe Item, "bought last friday" do
    subject { Item.new(:when => "Last friday") }

    its(:when) { should == Date.new(2010, 03, 26) }
  end

  describe Item, "bought this friday" do
    subject { Item.new(:when => "this friday") }

    its(:when) { should == Date.new(2010, 04, 02) }
  end
end

describe Item, "with a photo_url" do
  before(:each) do
    FakeWeb.register_uri(:get, "http://test.host/picture.png", :body => "data")
  end

  subject { 
    Factory.build(:item, :photo => nil, :photo_url => "http://test.host/picture.png") 
  }
  
  context "when the photo exists" do
    before(:each) do
      @picture = File.read(root_path('spec/fixtures/files/picture.png'))

      FakeWeb.register_uri(:get, "http://test.host/picture.png", :body => @picture)
    end

    it { should be_valid }

    it "should save the photo from the url" do
      subject.save!

      subject.photo_file_name.should_not be_nil
    end
  end

  context "when the does not exist" do
    before(:each) do 
      FakeWeb.register_uri(:get, "http://test.host/picture.png",
                           :body => '', :status => ["404", "Not Found"])
    end
    
    it { should_not be_valid }
  end
end

describe Item, "successfully posted" do
  it "should be broadcasted to twitter" do
    user = Factory(:user)
    item = Factory.build(:item, :user => user)

    item.should_receive(:broadcast_to_twitter)
    item.save
  end
end

describe Item, "#broadcast_to_twitter" do
  before(:each) do
    Resque.stub!(:enqueue)
    FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json",
                         :body => {:id => 123145}.to_json)
    @item = Factory(:item, :user => Factory(:user))
  end

  describe "on success" do
    it "saves the twitter status id to the item" do
      Resque.should_receive(:enqueue).with(Purchase, @item.id, @item.user_id)
      @item.twitter_status_id = nil
      @item.broadcast_to_twitter
    end
  end

  describe "on failure" do
    it "sets the twitter status id to nil" do
      FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json",
                           :body => '', :status => ["404", "Not Found"])

      @item.broadcast_to_twitter
      @item.twitter_status_id.should be_nil
    end
  end
end

describe Item, "with no src twitter status id" do
  it "should be creatable" do
    lambda {
      Factory(:item)
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end
end

describe Item, "with a src twitter status id that doesn't exist yet" do
  it "should be creatable" do
    lambda {
      Factory(:item, :src_twitter_status_id => 1001)
    }.should_not raise_error(ActiveRecord::RecordInvalid)
  end

  context "when another item comes in with the same src twitter status id" do
    it "should not be creatable" do
      Factory(:item, :src_twitter_status_id => 1001)

      lambda {
        Factory(:item, :src_twitter_status_id => 1001)
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
end

describe Item, "with a date like Nov 28, 2009" do
  subject do
    @item = Item.new(:when => "Nov 28, 2009")
    @item.valid?
    @item
  end

  its(:when) { should == Date.new(2009, 11, 28) }
end

describe Item, "with an unparseable date like 'Last Foobar'" do
  subject do
    @item = Item.new(:when => "Last FooBar")
  end
  
  it { should_not be_valid }

  it do
    subject.valid?
    subject.errors[:when].should_not be_empty
  end
end

describe Item, "with no date given" do
  subject do
    @item = Item.new(:when => "")
  end
  
  it { should_not be_valid }

  it do
    subject.valid?
    subject.errors[:when].should be_empty
  end
end
