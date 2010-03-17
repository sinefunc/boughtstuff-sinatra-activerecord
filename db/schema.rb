# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100317130019) do

  create_table "items", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "body"
    t.integer  "price"
    t.string   "where"
    t.date     "when"
    t.text     "description"
    t.string   "twitter_status_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",                         :default => 0
    t.integer  "views_count",                         :default => 0
    t.string   "src_twitter_status_id", :limit => 20
  end

  add_index "items", ["src_twitter_status_id"], :name => "index_items_on_src_twitter_status_id", :unique => true
  add_index "items", ["views_count"], :name => "index_items_on_views_count"

  create_table "likes", :force => true do |t|
    t.integer  "liker_id"
    t.integer  "liked_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["item_id", "liker_id"], :name => "index_likes_on_item_id_and_liker_id", :unique => true
  add_index "likes", ["liked_id", "item_id"], :name => "index_likes_on_liked_id_and_item_id"
  add_index "likes", ["liker_id", "item_id"], :name => "index_likes_on_liker_id_and_item_id"

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.string  "taggable_type", :default => ""
    t.integer "taggable_id"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name", :default => ""
    t.string "kind", :default => ""
  end

  add_index "tags", ["name", "kind"], :name => "index_tags_on_name_and_kind"

  create_table "tempitems", :force => true do |t|
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "boughtstuff_username",         :limit => 20
  end

  add_index "users", ["boughtstuff_username"], :name => "index_users_on_boughtstuff_username"

end
