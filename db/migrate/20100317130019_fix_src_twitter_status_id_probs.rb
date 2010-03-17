class FixSrcTwitterStatusIdProbs < ActiveRecord::Migration
  def self.up
    change_column :items, :src_twitter_status_id, :string, :default => nil, :limit => 20
    remove_index :items, :src_twitter_status_id
    add_index :items, :src_twitter_status_id, :unique => true
  end

  def self.down
  end
end
