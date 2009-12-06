class Item < ActiveRecord::Base
  has_attached_file :photo, 
    :styles => {
      :medium => "300x300>", :thumb => "100x100>",
    },
    :storage => :s3,
    :s3_credentials => Rails.root.join('config', 's3.yml').to_s,
    :path => ":attachment/:id/:style.:extension",
    :bucket => AppConfig.s3.bucket
  
  composed_of :price, 
              :class_name => "Money", 
              :mapping => [ %w(cents cents), %w(currency currency) ]
              
  alias_method :price_without_hash=, :price=
  
  def price=( money_or_hash )
    case money_or_hash
    when Hash
      self.price_without_hash = build_money_from_hash(money_or_hash)
        
    else
      self.price_without_hash = money_or_hash
    end
  end
  
  private
    def build_money_from_hash( hash )
      Money.new(
        hash['value'] * 100, 
        hash['currency'].blank? ? Money.default_currency : hash['currency']
      )
    end
end