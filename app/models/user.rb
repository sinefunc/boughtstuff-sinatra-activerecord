class User < Ohm::Model
  include RaiseOnInvalidConcerns
  include CallbackConcerns
  extend  FinderConviences
  include FriendshipConcerns

  collection :items, Item

  attribute :login
  attribute :name
  attribute :twitter_id
  attribute :username
  attribute :nickname
  attribute :avatar_url
  attribute :data

  index     :login
  index     :twitter_id
  index     :username
  index     :nickname
  
  before_save :generate_canonical_username
  
  def self.find_by_username( username )
    find(nickname: username).first || find(username: username).first
  end

  def self.find_or_create_by( attrs )
    user = first(twitter_id: attrs[:id]) || new(twitter_id: attrs[:id])
    user.login = attrs[:screen_name]
    user.name  = attrs[:name]
    user.avatar_url = attrs[:avatar_url]
    user.save
  end

  def validate
    assert_present :login
    assert_present :twitter_id
    assert_present :name

    assert_unique  :login
    assert_unique  :twitter_id
  end
  
  private
    def generate_canonical_username
      self.username = login.gsub(/[^a-z0-9]/, '-')
    end
end
