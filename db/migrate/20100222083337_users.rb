class Users < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.integer  "twitter_id"
      t.string   "login"
      t.string   "access_token"
      t.string   "access_secret"
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"
      t.string   "name"
      t.string   "location"
      t.string   "description"
      t.string   "profile_image_url"
      t.string   "url"
      t.boolean  "protected"
      t.string   "profile_background_color"
      t.string   "profile_sidebar_fill_color"
      t.string   "profile_link_color"
      t.string   "profile_sidebar_border_color"
      t.string   "profile_text_color"
      t.string   "profile_background_image_url"
      t.boolean  "profile_background_tile"
      t.integer  "friends_count"
      t.integer  "statuses_count"
      t.integer  "followers_count"
      t.integer  "favourites_count"
      t.integer  "utc_offset"
      t.string   "time_zone"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :users
  end
end
