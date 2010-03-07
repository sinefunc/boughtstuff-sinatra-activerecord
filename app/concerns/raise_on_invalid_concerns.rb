module RaiseOnInvalidConcerns
  class RecordInvalid < StandardError; end

  def save!
    if not valid?
      raise RecordInvalid, errors.inspect
    else
      return save
    end
  end
end
