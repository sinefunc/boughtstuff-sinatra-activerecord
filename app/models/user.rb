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
