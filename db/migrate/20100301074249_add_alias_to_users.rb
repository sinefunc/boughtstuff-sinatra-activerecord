class AddAliasToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :boughtstuff_username, :string, :limit => 20
    add_index  :users, :boughtstuff_username
  end

  def self.down
    remove_index  :users, :boughtstuff_username
    remove_column :users, :boughtstuff_username
  end
end
