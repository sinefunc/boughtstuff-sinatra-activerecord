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

  validates_attachment_presence :photo, :unless => :tempitem_id_or_photo_url?

  scope :latest,      order('id DESC')
  scope :most_viewed, order('id DESC')
  scope :most_liked,  where('likes_count != 0').order('likes_count DESC')
  scope :tagged,      lambda { |t| includes(:tags).where('tags.name' => t) }

  belongs_to :user
  has_many   :likes, :dependent => :destroy
  
  attr_accessor :tempitem_id
  attr_readonly :views_count, :likes_count

  before_save  :copy_temp_photo
  after_create :broadcast_to_twitter

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
      write_attribute(
        :when, 
        Chronic.parse(
          date_time_or_string, :now => Time.now.utc
        ).try(:to_date)
      )
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

  private
    def tempitem_id_or_photo_url?
      tempitem_id.present? or photo_url.present?
    end

    def valid_amount?( amount )
      begin
        Kernel.Float(amount)
      rescue ArgumentError, TypeError
        return false
      else
        return true
      end
    end

    def copy_temp_photo
      if tempitem_id.present?
        tempitem = Tempitem.find(tempitem_id)
        self.photo = tempitem.photo.to_file
      end
    end
end
