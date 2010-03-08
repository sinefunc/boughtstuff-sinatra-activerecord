# -------------------------
# Table users
#
# id: integer
# twitter_id: string
# login: string
# access_token: string
# access_secret: string
# remember_token: string
# remember_token_expires_at: datetime
# name: string
# location: string
# description: string
# profile_image_url: string
# url: string
# protected: boolean
# profile_background_color: string
# profile_sidebar_fill_color: string
# profile_link_color: string
# profile_sidebar_border_color: string
# profile_text_color: string
# profile_background_image_url: string
# profile_background_tile: boolean
# friends_count: integer
# statuses_count: integer
# followers_count: integer
# favourites_count: integer
# utc_offset: integer
# time_zone: string
# created_at: datetime
# updated_at: datetime
# boughtstuff_username: string

class User < ActiveRecord::Base
  validates :login, :uniqueness => true, :presence => true
  validates :twitter_id, :uniqueness => true, :presence => true
  
  has_many :tempitems, :dependent => :destroy

  has_many :items, :dependent => :destroy
  has_many :likes, :dependent => :destroy, :foreign_key => 'liker_id'
  has_many :likes_items, :through => :likes, :source => :item

  has_many :liked_by_others, :foreign_key => 'liked_id', :class_name => 'Like'
  has_many :liked_items_by_others, :through => :liked_by_others, :source => :item,
    :select => "DISTINCT(items.id), items.*"

  include TwitterFriends

  before_save :generate_canonical_username_from_login
  
  def self.find_or_create_by( attrs, access_token )
    user = find_or_initialize_by_twitter_id( attrs[:id] )
    user.login              = attrs[:screen_name]
    user.name               = attrs[:name]
    user.profile_image_url  = attrs[:profile_image_url]
    user.access_token       = access_token.first
    user.access_secret      = access_token.last
    user.save
    user
  end

  def self.find_by_username( username )
    find_by_boughtstuff_username( username ) || find_by_login( username )
  end

  def total_spending
    items.total_spending
  end

  def to_s
    first_name
  end

  def username
    boughtstuff_username? ? boughtstuff_username : login.gsub(/[^a-z0-9]/, '-') 
  end

  def first_name
    name.split(' ').first
  end

  def likes?( item )
    likes_items.exists?(:id => item.id)
  end
  
  def avatar_url
    profile_image_url
  end
  
  def twitter
    @twitter ||= TwitterProxy.new( self )
  end

  private
    def generate_canonical_username_from_login
      self.boughtstuff_username = login.gsub(/[^a-z0-9]/, '-') unless boughtstuff_username?
    end
end
