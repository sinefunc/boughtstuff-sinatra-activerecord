class TwitterDirectMessage
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  validates :body,
    :presence => true,
    :length   => { :within => 1..140 }

  validates :sender, :recipient,
    :presence => true
  
  attr_accessor :body, :sender, :recipient
  attr_reader   :last_response, :id

  def initialize(attributes = {})
    attributes.each { |k,v| self.send "#{k}=", v }
  end
 
  def to_model
    self
  end

  def save
    self.last_response = sender.twitter.post("/direct_messages/new.json", 
      :text => body, :user => recipient.twitter_id
    )
    self.id = self.last_response["id"].to_s
    return true
  rescue # TwitterAuth::Dispatcher::Error
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

