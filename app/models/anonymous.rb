class Anonymous
  def items
    Item.where
  end

  def likes_items
    Item.most_liked 
  end
end
