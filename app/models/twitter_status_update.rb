class TwitterStatusUpdate
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  attr_accessor :body, :sender, :in_reply_to_status_id
  attr_reader   :id, :last_response

  validates :body,
    :presence => true,
    :length   => { :within => 1..140 }

  validates :sender, :presence => true
  
  def self.create( attrs = {} )
    status_update = new( attrs )  
    status_update.save ? status_update.id : nil
  end

  def initialize(attributes = {})
    attributes.each { |k,v| self.send "#{k}=", v }
  end

  def to_model
    self
  end

  def save
    params = { :status => self.body }

    if self.in_reply_to_status_id
      params.merge!(:in_reply_to_status_id => self.in_reply_to_status_id) 
    end
    self.last_response = sender.twitter.post("/statuses/update.json", 
                                              params)
    self.id = last_response["id"].to_s
    return true
  rescue TwitterProxy::Unauthorized, TwitterProxy::Error
    # TODO: Add an error in the object
    return false
  end

  def new_record?
    id.nil?
  end

  private

    def last_response=(response)
      @last_response = response
    end
    
    def id=(new_id)
      @id = new_id
    end

end

