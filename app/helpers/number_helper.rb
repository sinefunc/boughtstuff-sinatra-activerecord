class Main
  helpers do
    def number_to_currency( number )
      format = (number.to_i == number) ? "$%.0f" : "$%.2f"

      case number 
      when 0..999_999
        sprintf format, number

      when 1_000_000..999_999_999 
        millions = number / 1_000_000.0
        
        sprintf( format, millions ) + 'M'
      else
        billions = number / 1_000_000_000.0
        
        sprintf( format, billions ) + 'B'
      end
    end
  end
end
