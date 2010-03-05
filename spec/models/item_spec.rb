require 'spec_helper'

describe Item do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price_in_dollars) }
  it { should validate_presence_of(:photo) }
  
  it { should validate(:price_in_dollars, :allow => "100.00") }
  it { should validate(:price_in_dollars, :allow => 100.00) }
  it { should validate(:price_in_dollars, :allow => 100) }
  it { should validate(:price_in_dollars, :allow => 1_000) }
  it { should validate(:price_in_dollars, :allow => "1_000") }
  it { should validate(:price_in_dollars, :allow => "1_000.00") }

  it { should validate(:price_in_dollars, :deny  => "abcde") }
  it { should validate(:price_in_dollars, :deny  => "1abcde") }
  it { should validate(:price_in_dollars, :deny  => "1.0abc") }
  it { should validate(:price_in_dollars, :deny  => "1,000") }
  it { should validate(:price_in_dollars, :deny  => -1000) }

  it { should reference(:user) }
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

