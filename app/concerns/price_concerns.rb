module PriceConcerns
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
