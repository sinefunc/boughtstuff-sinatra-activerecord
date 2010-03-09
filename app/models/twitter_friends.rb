module TwitterFriends
  URL = "http://api.twitter.com/1/friends/ids.xml"
  
  # TODO : cache this
  def friends
    twitter_ids = Hash.from_xml(twitter.get(URL))['ids']['id']
    User.where(:twitter_id => twitter_ids)
  end
  
  def friends_ids
    friends.map(&:id)
  end

  def friends_items
    Item.where(:user_id => friends_ids)
  end

  def friends_likes
    Like.where(:liker_id => friends_ids).includes(:item)
  end
end
