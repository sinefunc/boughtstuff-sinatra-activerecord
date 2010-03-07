class Item < Ohm::Model
  include CallbackConcerns
  include RaiseOnInvalidConcerns
  include PriceConcerns
  include SpendingConcerns
  include DateParsingConcerns
  include Timestamping

  reference  :user,  User
  collection :items, Item

  # - CORE FIELDS -
  attribute :name
  attribute :body
  attribute :price
  attribute :where
  attribute :when
  attribute :description
  attribute :twitter_status_id

  # - PHOTO RELATED -
  attribute :photo_file_name
  attribute :photo_content_type
  attribute :photo_file_size
  attribute :photo_updated_at
  
  attribute :timestamp

  counter   :likes_count
  counter   :views_count
  
  attr_accessor :photo

  def validate
    assert_present :name
    assert_present :price_in_dollars
    assert_present :photo
    assert_present :user

    assert valid_amount?(price_in_dollars), [ :price_in_dollars, :not_numeric ]
  end

  def when=( date )
    write_date( :when, date )
  end

  def when
    read_date( :when )
  end

  def to_s
    name    
  end
  alias :inspect :to_s
end
