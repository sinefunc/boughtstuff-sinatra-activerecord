require 'app/models/user'

class Item < Ohm::Model
  DATE_FORMAT = "%Y-%m-%d"

  reference :user, User

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
  
  attribute :created_at
  attribute :updated_at

  counter   :likes_count
  counter   :views_count
  
  attr_accessor :photo

  def validate
    assert_present :name
    assert_present :price_in_dollars
    assert_present :photo
    
    assert valid_amount?(price_in_dollars), [ :price_in_dollars, :not_numeric ]
  end


  def price_in_dollars=( amount )
    self.price = (amount.to_f * 100) if valid_amount?(amount)
    @price_in_dollars = amount
  end

  def price_in_dollars
    if price
      @price_in_dollars ||= (price.to_f / 100)
    else
      @price_in_dollars
    end
  end

  def when=( date_time_or_string )
    case date_time_or_string
    when Date, Time, DateTime
      write_local(:when, date_time_or_string.strftime(DATE_FORMAT))
    when String     
      if parsed = Chronic.parse(date_time_or_string, :now => Time.now.utc)
        write_local(:when, parsed.strftime(DATE_FORMAT))
      end
    end
  end

  def when
    if val = read_local(:when) 
      Date.new(*val.split('-').map(&:to_i))
    end
  end
  private
    def valid_amount?( amount )
      begin
        val = Kernel.Float(amount)
      rescue ArgumentError, TypeError
        return false
      else
        val >= 0
      end
    end
end
