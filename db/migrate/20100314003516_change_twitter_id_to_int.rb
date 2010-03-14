class ChangeTwitterIdToInt < ActiveRecord::Migration
  def self.up
    change_column :users, :twitter_id, :integer
  end

  def self.down
  end
end
