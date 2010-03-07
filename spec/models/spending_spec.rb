require 'spec_helper'

describe Spending, "total" do
  it "should be initially 0" do
    Spending.total.should == 0
  end
end

describe Spending, 'after cyx creates a $999 item' do
  before( :each ) do
    @cyx  = Factory(:user, :login => 'cyx')
    @item = Factory(:item, :user => @cyx, :price_in_dollars => 999)
  end

  it "should up cyx's total aggregated spending" do
    Spending.total( @cyx ).should == 999_00
  end

  it "should up all the people's aggregated spending as well" do
    Spending.total.should == 999_00
  end

  context 'after cyx deletes his item' do
    before( :each ) do
      @item.delete
    end

    it "should reduce cyx's spending to 0" do
      Spending.total( @cyx ).should == 0 
    end

    it "should reduce all people's spending to 0" do
      Spending.total.should == 0 
    end
  end

  context 'after marco also creates a $1800 item' do
    before( :each ) do
      @marco = Factory(:user, :login => 'marco')
      @item  = Factory(:item, :user => @marco, :price_in_dollars => 1800)
    end

    it "should up marco's total aggregated spending to 1800" do
      Spending.total( @marco ).should == 1800_00
    end

    it "should up everybody's total spending to 2799" do
      Spending.total.should == 2799_00 
    end
  end
end
