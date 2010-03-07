class ItemUrl < Struct.new(:username, :item_id)
  def self.make( item )
    new( item.user.username, item.id ).to_s
  end

  def to_s
    "http://#{username}.boughtstuff.com/##{item_id}"
  end
end
