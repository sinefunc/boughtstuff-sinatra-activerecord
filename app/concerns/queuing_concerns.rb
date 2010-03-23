module QueuingConcerns
  def self.included( base )
    base.extend ClassMethods
  end

  module ClassMethods
    def perform(body, item_id, sender_id)
      item, sender = Item.find(item_id), User.find(sender_id)

      model = new(:body => body, :item => item, :sender => sender)
      model.save( :sync )
    end
  end

  def save(strategy = :async)
    if valid?
      if strategy == :async
        Resque.enqueue(self.class, body, sender.id, item.id)
        true
      else
        super()
      end
    else
      return false
    end
  end
end
