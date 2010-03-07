module Timestamping
  def self.included( base )
    base.before_save :update_timestamp
  end

  private
    def update_timestamp
      self.timestamp = Time.now.utc.to_f * 100
    end
end
