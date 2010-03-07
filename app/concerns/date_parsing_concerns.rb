module DateParsingConcerns
  DATE_FORMAT = "%Y-%m-%d"

  def write_date( field, date_time_or_string )
    case date_time_or_string
    when Date, Time, DateTime
      write_local(field, date_time_or_string.strftime(DATE_FORMAT))
    when String     
      if parsed = Chronic.parse(date_time_or_string, :now => Time.now.utc)
        write_local(field, parsed.strftime(DATE_FORMAT))
      end
    end
  end

  def read_date( field )
    if val = read_local(field) 
      Date.new(*val.split('-').map(&:to_i))
    end
  end
end
