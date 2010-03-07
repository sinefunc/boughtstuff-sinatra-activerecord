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
    attrs.each { |k, v| send("#{k}=", v) }

    if @item and @body.blank?
      template = render(:url => ItemUrl.make(@item), :username => @item.user.login)
      self.body = sprintf(template, @item.to_s)
    end
  end

  def save
    if valid? && (self.id = TwitterStatusUpdate.create(:sender => sender, :body => body))
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

  private
    def render( attrs = {} )
      returning self.class.template.dup do |ret|
        attrs.each { |k, v| ret.gsub!(":#{k}", v) }
      end
    end
end
