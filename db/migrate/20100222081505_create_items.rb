class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :user_id
      t.string :name
      t.text :body
      t.integer :price
      t.string  :where
      t.date    :when
      t.text    :description

      t.string :twitter_status_id
    
      t.string   :photo_file_name, :photo_content_type
      t.integer  :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
