require 'spec_helper'

describe Item do
  describe "given a price with Money 1000, USD" do
    before(:each) { @item = Item.new(:price => Money.new(1000)) }

    it do
      @item.cents.should == 1000
    end
    
    it do
      @item.currency.should == 'USD'
    end
  end
  
  describe "given a price => { 'value' => 10 }" do
    before(:each) { @item = Item.new(:price => { 'value' => 10 }) }
    
    it do
      @item.cents.should == 1000
    end
    
    it do
      @item.currency.should == 'USD'
    end
  end
end