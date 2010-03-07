class Like < ActiveRecord::Base
  validates_presence_of :item, :liker

  belongs_to :item, :counter_cache => true
  belongs_to :liker, :class_name => 'User'
   
  before_save lambda { |like| like.liked_id = like.item.user_id }

  scope :latest, order('id DESC')
end
