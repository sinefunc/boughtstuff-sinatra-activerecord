require "test_helper"

class ItemTest < Test::Unit::TestCase
  describe "Item" do
    setup do
      @model = Item.new
    end

    should_validate_presence_of :name
    should_validate_presence_of :price_in_dollars
    should_validate_presence_of :photo
  end
end
