class AddSrcTwitterStatusIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :src_twitter_status_id, :integer
    add_index  :items, :src_twitter_status_id
  end

  def self.down
    remove_index  :items, :src_twitter_status_id
    remove_column :items, :src_twitter_status_id
  end
end
