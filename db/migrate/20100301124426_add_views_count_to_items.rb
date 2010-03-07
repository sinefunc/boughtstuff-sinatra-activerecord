class AddViewsCountToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :views_count, :integer, :default => 0
    add_index  :items, :views_count
  end

  def self.down
    remove_index  :items, :views_count
    remove_column :items, :views_count
  end
end
