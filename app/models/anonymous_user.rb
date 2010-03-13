class AnonymousUser
  USERNAME = 'everyone' 

  def items
    Item.where
  end

  def likes_items
    Item.most_liked 
  end

  def username
    USERNAME
  end
end
