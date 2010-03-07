require 'spec_helper'

describe Like do
  before(:each) { @like = Like.new }

  it { @like.should belong_to(:item) }

  describe "given cyx likes marco's iphone 3GS" do
    before( :each ) do
      @marco = Factory(:user, :login => 'marco')
      @cyx   = Factory(:user, :login => 'cyx')

      @iphone = Factory(:item, :name => 'iPhone 3GS', :user => @marco)

      @like = @cyx.likes.create!(:item => @iphone)
    end

    it "should add the like to cyx's likes" do
      @cyx.likes.should include(@like)
    end

    it "should add the iphone to cyx's likes_items" do
      @cyx.likes_items.should include(@iphone)
    end

    it "should add the iphone to marco's liked_items_by_others" do
      @marco.liked_items_by_others.should include(@iphone)
    end

    describe "when tim also likes marco's iphone" do
      before(:each) do
        @tim = Factory(:user, :login => 'tim')
        @tim.likes.create!(:item => @iphone)
      end

      it "should still hold that marco has only 1 liked items by others" do
        @marco.should have(1).liked_items_by_others
      end

      describe "when tim likes marcos Macbook Pro 15" do
        before( :each ) do
          @mbp = Factory(:item, :name => 'Macbook Pro 15', :user => @marco)
          @tim.likes.create!(:item => @mbp)
          @marco.reload
        end

        it "should add the mbp to marco's liked items by others" do
          @marco.liked_items_by_others.should include(@mbp) 
        end

        it "should mean marco's liked items by others are now 2" do
          @marco.should have(2).liked_items_by_others
        end
      end
    end
  end
end
