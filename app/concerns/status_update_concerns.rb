module StatusUpdateConcerns
  class StatusInvalid < StandardError; end

  def self.included( base )
    base.send :include, ActiveModel::Validations
    base.send :attr_accessor, :body, :id, :sender, :item
  
    base.validates :sender, :presence => true
    base.validates :body,   :length => { :within => 1..140 }
    base.extend ClassMethods
  end
  
  module ClassMethods
    def template( str = nil )
      if str
        @template = str
      else
        @template
      end
    end

    def post( item, sender )
      model = new(:item => item, :sender => sender)
      model.save
      model.id
    end
  end

  def initialize( attrs = {} )
    attrs.each { |field, value| write(field, value) }

    if @item and @body.blank?
      template = render(:url => ItemUrl.make(@item), :username => @item.user.login,
                        :content => content)
      self.body = sprintf(template, @item.to_s)
    end
  end

  def save
    if valid? && (self.id = TwitterStatusUpdate.create(:sender => sender, :body => body, :in_reply_to_status_id => @item.twitter_status_id))
      return true
    else
      return false
    end
  end

  def save!
    if save
      return true
    else
      raise StatusInvalid
    end
  end

  def to_key
    nil
  end

  def to_param
    id
  end

  def persisted?
    id.present?
  end

  def to_model
    self 
  end

  def item_id
    item ? item.id : nil
  end

  def item_id=( item_id )
    self.item = Item.find(item_id)
  end

  def content
    ""
  end

  private
    def render( attrs = {} )
      self.class.template.dup.tap do |ret|
        attrs.each { |k, v| ret.gsub!(":#{k}", v) }
      end
    end

    def write( field, value )
      send("#{field}=", value) 
    end
end
