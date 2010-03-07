class Spending < Ohm::Model
  reference :user, User
  attribute :amount

  def self.total=( amount_or_array )
    case amount_or_array
    when String, Fixnum, Float
      self.total = [ amount_or_array, nil ]
    when Array
      amount, user = amount_or_array
      
      raise ArgumentError unless user.is_a?(User) or user.nil?
      user_id = user.try(:id)

      spending = find(user_id: user_id).first
      spending = new(user_id: user_id) if not spending
      spending.amount = amount
      spending.save
    else
      raise ArgumentError, "total= accepts only an amount or array"
    end
  end

  def self.total( user = nil )
    user_id = user ? user.id : nil

    find(user_id: user_id).first.try(:amount) || 0
  end

  def amount
    read_local(:amount).to_f
  end
end
