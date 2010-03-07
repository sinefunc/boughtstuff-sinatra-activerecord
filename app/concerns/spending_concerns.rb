module SpendingConcerns
  def self.included( base )
    base.after_save   :increase_spending
    base.after_delete :decrease_spending
  end

  protected
    def increase_spending
      Spending.total = [ Spending.total(user) + self.price, user ]
      Spending.total = Spending.total + self.price
    end

    def decrease_spending
      Spending.total = [ Spending.total(user) - self.price, user ]
      Spending.total = Spending.total - self.price
    end
end
