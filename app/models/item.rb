class Item < ActiveRecord::Base
  include PhotoUrlConcerns
  include PhotoAttachment

  is_taggable       :tags

  validates :user, :presence => true

  validates :name,  
    :presence   => true,
    :length     => { :maximum => 255 }

  validates :price_in_dollars, 
    :presence => true,
    :numericality => { :allow_blank => true, :greater_than_or_equal_to => 0 }
  
  validates :src_twitter_status_id,
    :uniqueness =>   { :allow_blank => true }
  
  validate  :when_was_parsed_correctly

  scope :latest,      order('id DESC')
  scope :most_viewed, order('views_count DESC')
  scope :most_liked,  where('likes_count != 0').order('likes_count DESC')
  scope :tagged,      lambda { |t| includes(:tags).where('tags.name' => t) }

  belongs_to :user
  has_many   :likes, :dependent => :destroy
  
  attr_readonly :views_count, :likes_count

  after_create :broadcast_to_twitter
  
  self.per_page = 15

  def self.total_spending
    sum(:price) / 100  
  end

  def price_in_dollars=( amount )
    write_attribute(:price, amount.to_f * 100) if valid_amount?(amount)
    @price_in_dollars = amount
  end

  def price_in_dollars
    if price
      @price_in_dollars ||= (price.to_f / 100)
    else
      @price_in_dollars
    end
  end

  def broadcast_to_twitter
    update_attribute(:twitter_status_id, Purchase.post(self, user))
  end
  
  def when=( date_time_or_string )
    case date_time_or_string
    when Date, Time 
      write_attribute(:when, date_time_or_string)
    when String     
      @when = date_time_or_string
      
      write_attribute :when, 
        Chronic.parse(date_time_or_string, :now => Time.now.utc).try(:to_date)
    end
  end

  def to_s
    name
  end
  
  def new?
    (Time.now.utc - created_at) <= 1.days
  end
  
  def viewed!
    self.class.increment_counter(:views_count, self.id)
  end

  def to_param
    "%s-%s" % [ id, name.gsub(/[^a-zA-Z0-9]/, '-').downcase ]
  end

  private
    def valid_amount?( amount )
      begin
        Kernel.Float(amount)
      rescue ArgumentError, TypeError
        return false
      else
        return true
      end
    end

    def when_was_parsed_correctly
      if @when.present? and read_attribute(:when).blank?
        errors.add(:when, I18n::t('errors.messages.invalid'))
      end
    end
end
