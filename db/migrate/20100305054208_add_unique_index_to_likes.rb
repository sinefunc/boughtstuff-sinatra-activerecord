class AddUniqueIndexToLikes < ActiveRecord::Migration
  def self.up
    add_index :likes, [ :item_id, :liker_id ], :unique => true
  end

  def self.down
    remove_index :likes, [ :item_id, :liker_id ]
  end
end
