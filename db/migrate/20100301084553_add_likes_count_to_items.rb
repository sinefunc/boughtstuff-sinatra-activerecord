class AddLikesCountToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :likes_count, :integer, :default => 0
  end

  def self.down
    remove_column :items, :likes_count
  end
end
