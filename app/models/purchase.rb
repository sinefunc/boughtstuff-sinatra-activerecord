class Purchase
  include StatusUpdateConcerns

  template ":content :url #boughtstuff"
  
  @queue = :twitter

  def self.perform( item_id, user_id )
    item, user = Item.find(item_id), User.find(user_id)
    item.update_attribute :twitter_status_id, post( item, user )
  end
  
  def content
    item.description? ? item.description[0, 76] : "just bought %.64s"
  end
end
