class CreateTempitems < ActiveRecord::Migration
  def self.up
    create_table :tempitems do |t|
      t.integer :user_id
    
      t.string   :photo_file_name, :photo_content_type
      t.integer  :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :tempitems
  end
end
